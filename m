Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79097E29CB
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408405AbfJXFTh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:19:37 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45610 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406809AbfJXFTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:19:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id r1so13484857pgj.12;
        Wed, 23 Oct 2019 22:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R4Qpue11zRbP6z8jWqVbc0HPRRdY1MnnS2DG8TFSNZE=;
        b=Le9HX99kwkofdfuaGDLYlD93OYMmAz0ui7OB+Gf9j5PKoxGXjUNHW3263e+zoqaptL
         OPVhzCR/5Sr/81rasnbqjmWuJu+Lt2HxSVAmIrwK8vMRiNxvPW/+dwZp+xoxh6NQGvU7
         gW5PvX/1EHqfEpBl2FXvESm3al9qUlOzNngsdEbWIZvSOK4mzMiQ1eHfxguLkn2S4NKo
         LXbS7SRiNoKPVWw/84u/rQMkM1o1etiCcbjL60ISnE+TpjUg4az7WfxDo7KlebVknCF6
         Sndo1Zte89XlU4wPUMML9hDajpj1HRFyNPsPwNHAEn+zbCfbC4N/NEoia5hzaAR3IA1h
         WFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R4Qpue11zRbP6z8jWqVbc0HPRRdY1MnnS2DG8TFSNZE=;
        b=TRhZqNsW7hMqHIY18juiXJFr41ZTht6THsA0tqzn606f23foVnKulGPr7TIG7DPSni
         DhybprfL5S4VZIIfS9XRBx0XDOY6vyYcJRNCRjp47Zku1ZFKfNXXASsEPki6eqpiGKY7
         npVh971AfekyJ7wc6TWFUajoVHxR0Ky1v2lvwyA48zaX3ZLl1Ap9N9OCXjyw8Dkhr9Sv
         XZYuIvotaUW0BkW78l7m2FpNPcyOVA6A+a/mt+xEGKpCRPGAhtp3XLVWKOCJSwtuChcL
         hdi4TsQ+XMaX92dS8ug3RGAre7nmPWmM7fBqnX3JibsJQhhyhlY/Mesij4oebP7xFmO2
         LJZA==
X-Gm-Message-State: APjAAAXYdwZLDjiNqNrv+GnvgvGqEz9QJIutraG8sO3XbfNCL14BU9s/
        pXZ8b42015HTqG2iFMH8b3sGJC3AnA==
X-Google-Smtp-Source: APXvYqzMlJMza8lkLM/ZvnpHLH51f/SsdzAW2vS337pS4FRKKEVVkZh//Ls2n8HFeiJB3xXgqI35vg==
X-Received: by 2002:a63:8443:: with SMTP id k64mr14828888pgd.307.1571894375723;
        Wed, 23 Oct 2019 22:19:35 -0700 (PDT)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id q11sm7612161pgq.71.2019.10.23.22.19.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 23 Oct 2019 22:19:35 -0700 (PDT)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     fw@strlen.de
Cc:     astracner@linkedin.com, davem@davemloft.net, kadlec@netfilter.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, praveen5582@gmail.com, zxu@linkedin.com
Subject: RE: [netfilter]: Fix skb->csum calculation when netfilter
Date:   Wed, 23 Oct 2019 22:19:33 -0700
Message-Id: <1571894373-11188-1-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20191024011218.GT25052@breakpoint.cc>
References: <20191024011218.GT25052@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian

Thanks for giving time for review. This fix is pretty important for SONiC OS (https://azure.github.io/SONiC/). So I really appreciate it.

>> inet_proto_csum_replace16 is called from many places, whereas this fix is
>> applicable only for nf_nat_ipv6_csum_update. where we need to update
>> skb->csum for ipv6 src/dst address change.
>
>Under which circumstances does inet_proto_csum_replace16 upate
>skb->csum correctly?

inet_proto_csum_replace16 calculates skb->csum correctly if skb->csum does not include 16-bit sum of IPv6 Header i.e skb->data points to UDP\TCP\ICMPv6 header while calling __skb_checksum_complete() on packet. Function inet_proto_csum_replace16 is called from  nf_nat_ipv6_csum_update(),  nf_flow_nat_ipv6_tcp(),  nf_flow_nat_ipv6_udp() and update_ipv6_checksum(). For all nf_*() functions, inet_proto_csum_replace16() will not update skb->csum correctly\completely. 
But I am not sure about update_ipv6_checksum() (in net/openvswitch/actions.c). This is where I seek help from experts. If even for update_ipv6_checksum(), skb->csum includes 16-bit sum of IPv6 Header then inet_proto_csum_replace16() does updates skb->csum correctly. Then our fix will be to remove below line from this function. Because change in UDP\TCP\ICMPv6 header checksum field and change in IPv6 SRC\DST address cancels each other for checksum calculation, i.e. no update to skb->csum is needed.
```
if (skb->ip_summed == CHECKSUM_COMPLETE && pseudohdr)
    skb->csum = ~csum_partial(diff, sizeof(diff),
            ~skb->csum);
```
>
>> So, I added a new function. Basically, I used a safe approach to fix it,
>> without impacting other cases. Let me know other options,  I am open to
>> suggestions.
>
>You seem to imply inet_proto_csum_replace16 is fine and only broken for ipv6
>nat.

Yeah, as mentioned above, I took safe approach to fix only nf_nat_ipv6_csum_update() part, where I am sure that skb->csum is broken. But I am not sure if (net/openvswitch/actions.c) needs this fix or not. Consider this my lack of expertise, So kindly suggest whether net/openvswitch/actions.c needs this fix or not. Note: I may not be able to test this part. After your suggestion, I will change my patch. Again Thanks for your time. 
