Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12FB351B866
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 09:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245522AbiEEHJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 03:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234477AbiEEHJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 03:09:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5904018E29;
        Thu,  5 May 2022 00:05:32 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.16.1.2) with ESMTP id 244LDqHD012012;
        Thu, 5 May 2022 00:04:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=IvZ59VBMCUfOAZJJ9yKKHCWaGLF30TtIMEy60rvzfbI=;
 b=d5w/6d6SoSWEzHF9Zkducbv0Skm8HvcJyegOfP4gEb8TmVInqqGxWifbSKLAqVbRDxqA
 2N5UaJUa3afg2nwbEMy5vHSpfLXKxHTyzDAvuSUl/iwoaWScMcZr4+pM8kRtc5eiD6t/
 BiZVAN/bJnPBB0L5iCyBZ2feVitPwFTrMNnPoYZmS42sCW+ueUYPK7B0PYtqgSaq8Syn
 pEzn+P3oS5z1vVSo6sbqCng55PZcjY0lZ3J4vRloUH85spp3jw6cCFZbnrA3v1aPTwCp
 lc+NhSJtOwF5i5R1socZx/MEcG+x5+61eJPW6D0s7boLzvrcdBYEBm9b3/g6D793A0Ge ug== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fuscx3sad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 00:04:58 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 5 May
 2022 00:04:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 5 May 2022 00:04:57 -0700
Received: from [10.9.118.10] (EL-LT0043.marvell.com [10.9.118.10])
        by maili.marvell.com (Postfix) with ESMTP id 4A67D3F70A1;
        Thu,  5 May 2022 00:04:50 -0700 (PDT)
Message-ID: <1f4b595a-1553-f015-c7a0-6d3075bdbcda@marvell.com>
Date:   Thu, 5 May 2022 09:04:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:100.0) Gecko/20100101
 Thunderbird/100.0
Subject: Re: [EXT] [PATCH] net: atlantic: always deep reset on pm op, fixing
 null deref regression
Content-Language: en-US
To:     Manuel Ullmann <labre@posteo.de>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <regressions@lists.linux.dev>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        Jordan Leppert <jordanleppert@protonmail.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        koo5 <kolman.jindrich@gmail.com>,
        Dmitry Bezrukov <dbezrukov@marvell.com>
References: <87czgt2bsb.fsf@posteo.de>
From:   Igor Russkikh <irusskikh@marvell.com>
In-Reply-To: <87czgt2bsb.fsf@posteo.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: _7rCjKR59eG9a8k1-WxBl1-Uiu8haI-J
X-Proofpoint-ORIG-GUID: _7rCjKR59eG9a8k1-WxBl1-Uiu8haI-J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_02,2022-05-04_02,2022-02-23_01
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> The impact of this regression is the same for resume that I saw on
> thaw: the kernel hangs and nothing except SysRq rebooting can be done.
> 
> The null deref occurs at the same position as on thaw.
> BUG: kernel NULL pointer dereference
> RIP: aq_ring_rx_fill+0xcf/0x210 [atlantic]
> 
> Fixes regression in cbe6c3a8f8f4 ("net: atlantic: invert deep par in
> pm functions, preventing null derefs"), where I disabled deep pm
> resets in suspend and resume, trying to make sense of the
> atl_resume_common deep parameter in the first place.
> 
> It turns out, that atlantic always has to deep reset on pm operations
> and the parameter is useless. Even though I expected that and tested
> resume, I screwed up by kexec-rebooting into an unpatched kernel, thus
> missing the breakage.
> 
> This fixup obsoletes the deep parameter of atl_resume_common, but I
> leave the cleanup for the maintainers to post to mainline.
> 
> PS: I'm very sorry for this regression.

Hi Manuel,

Unfortunately I've missed to review and comment on previous patch - it was too quickly accepted.

I'm still in doubt on your fixes, even after rereading the original problem.
Is it possible for you to test this with all the possible combinations?
suspend/resume with device up/down,
hibernate/restore with device up/down?

I'll try to do the same on our side, but we don't have much resources for that now unfortunately..


> Fixes: cbe6c3a8f8f4315b96e46e1a1c70393c06d95a4c

That tag format is incorrect I think..

Igor
