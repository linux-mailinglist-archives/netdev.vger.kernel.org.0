Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B42182D0CB
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfE1VCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:02:36 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:36959 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfE1VCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:02:36 -0400
Received: by mail-pg1-f177.google.com with SMTP id n27so11708584pgm.4
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 14:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=c7ceyE43Xyn0ahYiGYoW3/Ms+/K6shUmeLNiiKXE+ls=;
        b=b6ySIiieuUqst46NfU1GbbB6HCVA/8E9t2dCEiU8Ipft08V/GPmVh/EXk51OawJ3GU
         C3ujodI+Xy11iocGsJW+tqhIFQpA1YjPQ8VnZdzDBgsts3v5D45i6OzV9n92L0HbE5u4
         9GLgpA4BPErbLHr4tAZahm0GtFue4P0yyYvVvNxRaOCZGfOzyKZoVm1uJaCqCELCizzw
         8jLRmO+H9WGPAqQeXS/SwR5XwCg8S49HKbBpbpTCiuvZsRGgWUZG1R0Cdud6Wnl8BTJF
         No+32G8viI4dMbVACmyEPgSxKZ9gwOBrI0pVTLKVLqSkWLdMrylRNEct9N/s27Z18LEL
         VPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c7ceyE43Xyn0ahYiGYoW3/Ms+/K6shUmeLNiiKXE+ls=;
        b=sShARVMSCibzJIWhRo7QLWWrTO00OPon6FIrNtEJCzzOr0WRHyJYCNjIS4GGnirRsK
         rXrfLAGCdF/oIZ9rCzF7fuauCXF2pkprEQefp/CP4RuYAx4cL3g/2Ri+V4joROAjiVvq
         2MfrTx8K5ZvxPedzgPslzR9A6gBpJheOBs1q8YAhwuUHsxIaWCxc74MGEnP/whQic+/+
         OW+ov3uDxd4LFpaLctw15qRP5RmkTFvFK0ws/fHm0kQr+GOlJP2peGneHfhtPIzBFEKe
         04D30+I1hGPkyxpW13sMDXBdE8v/zWJj7tAiBb0xnchG++xCNHmPS4Isp3nNsrfrJPX2
         PuLQ==
X-Gm-Message-State: APjAAAWoj/kAvTc8irGdWd/jHxuZkiI8/v/wWxEMCKOxaLPX5scMSQM1
        StOfEnpK3XbPvEb3JrIlyl4=
X-Google-Smtp-Source: APXvYqyMU7cycacggdcQpLy+VRgdeavqnTSMV3DGIOJPUSOqgtpxdu2GHWoS0KA4uQq+b7qGDbyb8Q==
X-Received: by 2002:a62:75d8:: with SMTP id q207mr112759856pfc.35.1559077356004;
        Tue, 28 May 2019 14:02:36 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id n9sm15701406pfq.53.2019.05.28.14.02.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 14:02:35 -0700 (PDT)
Subject: Re: [PATCH net] net/sched: act_pedit: fix 'ex munge' on network
 header in case of QinQ packet
To:     Davide Caratti <dcaratti@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     shuali@redhat.com, Eli Britstein <elibr@mellanox.com>
References: <753b96cc340e4fbae6640da070aac09d7220efe2.1559075758.git.dcaratti@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <290a8e03-1d24-a84f-751c-6fc27f04bba0@gmail.com>
Date:   Tue, 28 May 2019 14:02:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <753b96cc340e4fbae6640da070aac09d7220efe2.1559075758.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/19 1:50 PM, Davide Caratti wrote:
> Like it has been done in commit 2ecba2d1e45b ("net: sched: act_csum: Fix
> csum calc for tagged packets"), also 'pedit' needs to adjust the network
> offset when multiple tags are present in the packets: otherwise wrong IP
> headers (but good checksums) can be observed with the following command:

...

> +again:
> +		switch (protocol) {
> +		case cpu_to_be16(ETH_P_8021AD): /* fall through */
> +		case cpu_to_be16(ETH_P_8021Q):
> +			if (skb_vlan_tag_present(skb) &&
> +			    !orig_vlan_tag_present) {
> +				protocol = skb->protocol;
> +				orig_vlan_tag_present = true;
> +			} else {
> +				struct vlan_hdr *vlan;
> +
> +				vlan = (struct vlan_hdr *)skb->data;
> +				protocol = vlan->h_vlan_encapsulated_proto;
> +				skb_pull(skb, VLAN_HLEN);
> +				skb_reset_network_header(skb);
> +				(*vlan_hdr_count)++;
> +			}
> +			goto again;

What prevents this loop to access data not yet in skb->head ?

skb_header_pointer() (or pskb_may_pull()) seems needed.


