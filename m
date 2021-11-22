Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834524592A6
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhKVQJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhKVQJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:09:00 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF38FC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:05:53 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id p19so16936178qtw.12
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=umOk/gw4UiauFL1VT6PDqvKnpLhkybcvcCmUKMSxx10=;
        b=TQ5pNZZLgtyoA7GcvZdqiHYSaeq/D9mMOk8onptkX+HyPdH2zi1PM1SoiwZjEizXnA
         Glx8NgcO2tbErq+k4cNw5uNSN/f+s9q2wIaV6Cd2d3HDE53Ey6HWNabrrO3Xyv2K2qAO
         mwKQpnDDF9gWz2DyIvO3RKo1OaDtDCWhfRexqonb8EV0UmesaCW1HNX4kgBHrhKiPqpQ
         JZztsd071lsyjRDv+kvp1mcf4/kCyKH4NBUCGbXlOm44wzHDCSGKCHaxzT07XGuyQttT
         4ywmCSFW7bGNynHBFq2tewDKxgErkUW/soj0wzvNknFzSkpH0bzwmlbZybCWb03ZoRun
         722A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=umOk/gw4UiauFL1VT6PDqvKnpLhkybcvcCmUKMSxx10=;
        b=tnsrmyutyPRys1veEnkTRIXPc6h+MuZK320yaMyN85JIU/RNIYorb1YqNpGIauucV3
         pggicHBdsNjOiBysQo0EhgANy6oklCtIih5OBRnFA23Q+NW0+fWunlIyHFfEtAotM7HA
         IoKDP2v8NheYq1csu+u5pteict/XSJrbIrV+GNwObUlagUIcsUk9enh8EJRRFAUT3dmB
         5m9vA+yE62Vboay+Hg8pv4DwnL4EZsPbJhJ6vyljZKKVQyoTAsbZQE55G5VVM10dLY1a
         sdu3zKQCgzYBGwheYvpbE1SFYp26bo5QB3saHqLBrNW8igv89yrgS0AdWdenD1C83HwG
         ERhQ==
X-Gm-Message-State: AOAM533ee3rteyuDWU08ZIblO5IthJa47lX3RX8F3PD206MuIotW38nS
        B5sOKFlQQ+7Vk10UOd72E7ENvp7yOA==
X-Google-Smtp-Source: ABdhPJxYN9OHKi9fcLKOS5ZOfgUnTJ2ZqlvBGEkOIrqO0fNvZ1ZOGZVJe3guWJCkl6ieDPDiZuRdmw==
X-Received: by 2002:ac8:588c:: with SMTP id t12mr32039405qta.325.1637597152767;
        Mon, 22 Nov 2021 08:05:52 -0800 (PST)
Received: from ssuryadesk ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id 22sm2100989qtw.12.2021.11.22.08.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 08:05:52 -0800 (PST)
Date:   Mon, 22 Nov 2021 11:05:46 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com, ebiederm@xmission.com,
        roopa@nvidia.com
Cc:     fw@strlen.de
Subject: IPCB isn't initialized when MPLS route is pointing to a VRF
Message-ID: <20211122160546.GA95191@ssuryadesk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We ran into a problem because IPCB isn't being initialized when MPLS is
egressing into a VRF. Reproducer script and its teardown are attached,
but they are only to illustrate our setup rather than seeing the problem
as it depends on what is in the skb->cb[].

We found this when h0 is sending an ip packet with DF=1 to 10.1.4.2 and
on ler1 the code path is as follows: mpls_forward() calls mpls_egress()
and then calls neigh_xmit(), which ends up calling __dev_queue_xmit()
and vrf_xmit() through dev_hard_start_xmit(). vrf_xmit() eventually will
call ip_output() and __ip_finish_output() that has the check for
IPCB(skb)->frag_max_size. The conditional happens to be true for us due
to IPCB isn't being initialized even though the packet size is small.
The packet then is dropped in ip_fragment().

The change in this diff is a way to fix:

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index ffeb2df8be7a..1d0a0151e175 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -310,6 +310,7 @@ static bool mpls_egress(struct net *net, struct mpls_route *rt,
 			      htons(hdr4->ttl << 8),
 			      htons(new_ttl << 8));
 		hdr4->ttl = new_ttl;
+		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		success = true;
 		break;
 	}
@@ -327,6 +328,7 @@ static bool mpls_egress(struct net *net, struct mpls_route *rt,
 			hdr6->hop_limit = dec.ttl;
 		else if (hdr6->hop_limit)
 			hdr6->hop_limit = hdr6->hop_limit - 1;
+		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
 		success = true;
 		break;
 	}

Here are my questions. Is this the best place to initialize the IPCB?
Would it be better done in vrf.c? I can work on the formal patch once we
agree on where the final fix should be 

Cc Florian Westphal since we found the problem after upgrading to kernel
version that has his commit bb4cc1a18856 ("net: ip: always refragment ip
defragmented packets"). But I think the bug is there without his commit
as well if (IPCB(skb)->flags & IPCB_FRAG_PMTU) happens to evaluate to
true.

Thanks,

Stephen.
