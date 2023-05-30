Return-Path: <netdev+bounces-6226-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A383971549F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 06:54:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CB631C20B15
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A031F17C0;
	Tue, 30 May 2023 04:54:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D617E9;
	Tue, 30 May 2023 04:54:45 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76441E3;
	Mon, 29 May 2023 21:54:43 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U24C7N010022;
	Mon, 29 May 2023 21:54:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=3C7rqfTKs3OhE/59qADlZbdCdA2iSx6m3r61x8RXtlM=;
 b=BzJ+K6AX7uRNYwLgkl1/kcp2g8XshZ9uWZrKPUrC+1zOYgBcTIxDybmctApvy0iV8UIh
 /jSnP0c1cZLV2399AfY6Q4kxXB2POUbgf1R2vnIgvrBnB86WcbvEnxxLDRupwj1Rfk/s
 78lq0jd9u7Dkw7SoXvL0CzEsxa3kmv2TPpABGAgHzVGH72DtJqrnrKruDeXHMHN57k71
 drhM2IGou0pw0tY8PEiIs01a89aTKWT3AW1UweXvwn3m593kRLDpgNyyCmgc38YHByuQ
 M91kdKjwajz4392oOuEcV7rSQMa/Ggx7MnmACyU+6cCb3Xqf7l6VPow1CNk201N6e3Q6 xw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3quhcm70u9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Mon, 29 May 2023 21:54:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 29 May
 2023 21:54:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 29 May 2023 21:54:19 -0700
Received: from localhost.localdomain (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with ESMTP id 542A03F7058;
	Mon, 29 May 2023 21:54:14 -0700 (PDT)
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <starmiku1207184332@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH] kernel: bpf: syscall: fix a possible sleep-in-atomic bug in __bpf_prog_put()
Date: Tue, 30 May 2023 10:24:09 +0530
Message-ID: <20230530045409.440958-1-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230529155327.585056-1-starmiku1207184332@gmail.com>
References: <20230529155327.585056-1-starmiku1207184332@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: y_V4fOJnu-uHhzWQxJt3PXDizA7mUnaa
X-Proofpoint-ORIG-GUID: y_V4fOJnu-uHhzWQxJt3PXDizA7mUnaa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_02,2023-05-29_02,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: starmiku1207184332@gmail.com

>
>+			// safely calling vfree() under any context
do we need this comment as code is self explanatory.

> 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
> 			schedule_work(&aux->work);
> 		} else {
>+			// depending on the vfree_atomic() branch in vfree()
same as above.

> 			bpf_prog_put_deferred(&aux->work);
> 		}
> 	}
>--
>2.25.1

