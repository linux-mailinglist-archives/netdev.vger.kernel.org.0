Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1313EE04E
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 12:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727730AbfD2KL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 06:11:28 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:54210 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727428AbfD2KL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 06:11:28 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 3865B400066;
        Mon, 29 Apr 2019 10:11:26 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 29 Apr
 2019 03:11:22 -0700
Subject: Re: [PATCH] net_sched: force endianness annotation
To:     Nicholas Mc Guire <hofrat@osadl.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1556430899-11018-1-git-send-email-hofrat@osadl.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <07d36e94-aad4-a263-bf09-705ee1dd59ed@solarflare.com>
Date:   Mon, 29 Apr 2019 11:11:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556430899-11018-1-git-send-email-hofrat@osadl.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24580.005
X-TM-AS-Result: No-4.292800-4.000000-10
X-TMASE-MatchedRID: O/y65JfDwwsOwH4pD14DsPHkpkyUphL9Nvjc2DbB99Wrkv7SfIzez2mt
        ukJWdiprNJnt9TW/xwYACvZf/rOov2c/On6gI+zz84dsinZ5e1hAq6/y5AEOOvVbyY0/zdkG8z7
        0XDTUjsZOk++lKId7iyISKQcUnlqDq8jCopVJlk10BEBFOTiHn30tCKdnhB581kTfEkyaZdz6C0
        ePs7A07fhmFHnZFzVqIamWssUXa64BevIcQN9A5G+FnJlIEuK1YTtPBk8rKR4ak2Ci3GfcjitY1
        vUCSu8aNiWmlXPkwJxfqo383V2C46tqoSd6FkMRh8xkx6AsMh4ZTSkqdqz5FucIl+0VmRmLNglg
        0VTTR7s35c5BnKCu9g==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.292800-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24580.005
X-MDID: 1556532687-g3uCOSzhz_G4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2019 06:54, Nicholas Mc Guire wrote:
> While the endiannes is being handled correctly sparse was unhappy with
> the missing annotation as be16_to_cpu()/be32_to_cpu() expects a __be16
> respectively __be32.
[...]
> diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
> index 1c8360a..3045ee1 100644
> --- a/net/sched/em_cmp.c
> +++ b/net/sched/em_cmp.c
> @@ -41,7 +41,7 @@ static int em_cmp_match(struct sk_buff *skb, struct tcf_ematch *em,
>  		val = get_unaligned_be16(ptr);
>  
>  		if (cmp_needs_transformation(cmp))
> -			val = be16_to_cpu(val);
> +			val = be16_to_cpu((__force __be16)val);
>  		break;
There should probably be a comment here to explain what's going on.  TBH
 it's probably a good general rule that any use of __force should have a
 comment explaining why it's needed.
AFAICT, get_unaligned_be16(ptr) is (barring alignment) equivalent to
 be16_to_cpu(*(__be16 *)ptr).  But then calling be16_to_cpu() again on
 val is bogus; it's already CPU endian.  There's a distinct lack of
 documentation around as to the intended semantics of TCF_EM_CMP_TRANS,
 but it would seem either (__force u16)cpu_to_be16(val); (which preserves
 the existing semantics, that trans is a no-op on BE) or swab16(val);
 would make more sense.

-Ed
