Return-Path: <netdev+bounces-6284-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B147971589D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BD9D1C20BD7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 08:34:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5491118F;
	Tue, 30 May 2023 08:34:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625946B2;
	Tue, 30 May 2023 08:34:00 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7093B0;
	Tue, 30 May 2023 01:33:59 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U24CQg010022;
	Tue, 30 May 2023 01:33:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=Gr4HVELVm8Dj8Dkd78nNW2LnnXJuEoqoXSfCjtwpvPk=;
 b=iUuAYrQd8EqUacfVmKO2DOXeNLnsu5UIy313DgIZNDHWq4gxOJbRK/w/xvznLs34k5Mw
 TwgY0AzYh97n0FQ33wkjB6N+x19DVX4LWt0ZjyviY2ZdZ/5IHazlBDnSmbVGAH+m92qj
 hJWc66fjh2UT4TISvkY/Xd5UG3WxhsPt/cD4Bt4Iw40BS4UdJUhniwnUQ1ksjgkNRyBD
 sXHbdsXxAr9N5RySgZD3q281cjGFGlQsr7dFo/TFs+scaCufZIzh2Z5wVOAQg9sMu5N0
 Mrh8+d2C3BwxBebL3BetXDhXHhRIrxd3tByHyyyGGkeVS25kBa3eZV4OiILL5pXVFWqv pQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3quhcm7k8j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 01:33:30 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 30 May
 2023 01:33:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 30 May 2023 01:33:28 -0700
Received: from localhost.localdomain (unknown [10.28.36.165])
	by maili.marvell.com (Postfix) with ESMTP id 5A38A3F7043;
	Tue, 30 May 2023 01:33:23 -0700 (PDT)
From: Ratheesh Kannoth <rkannoth@marvell.com>
To: <starmiku1207184332@gmail.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>
CC: <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2] kernel: bpf: syscall: fix a possible sleep-in-atomic bug in __bpf_prog_put()
Date: Tue, 30 May 2023 14:03:20 +0530
Message-ID: <20230530070610.600063-1-starmiku1207184332@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230530070610.600063-1-starmiku1207184332@gmail.com>
References: <20230530070610.600063-1-starmiku1207184332@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: uc-eUWaHgh1J_o_bm7vDwK3KlxTicwoM
X-Proofpoint-ORIG-GUID: uc-eUWaHgh1J_o_bm7vDwK3KlxTicwoM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_05,2023-05-29_02,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: starmiku1207184332@gmail.com

> 			INIT_WORK(&aux->work, bpf_prog_put_deferred);
> 			schedule_work(&aux->work);
> 		} else {
>--
>2.25.1

