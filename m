Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE07B6B581C
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 04:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCKDla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 22:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjCKDl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 22:41:29 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ACD12EACD
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 19:41:28 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id h8so7636946plf.10
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 19:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678506087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5NvXwZzaPCbq6uRhEkZ6ujOHeAaYaBBfV8EWkiAGW0E=;
        b=gBF+mXgavmgwEf3kP5cPJ3mPSyenvWQxRxMUM/I+ZNDI5mK0zUSnhgmzfWYxnp5/SG
         2opa83CFBpQiB72QZhT21gCN87jowZmTTr9cOAteG32TjQJMyH+Hwt31dPIxwbX5H/bH
         pP1aYVebNhryy24v5hsyKvJEPJo8Dn6iw2C482DQcbdA0TGY1hXeGbietAqCw8+MEDAK
         YpjvBkCpbtZ+0l5OX14xZfd/+XUpXm1WeHSZAszNa/N0Ihs+UQJHWpZ33sw5+j84NIAO
         7JyM8EV/61ecyQTpQcqoqtPKLjDb6O97MKoALWnd3xH8+unTcbHNt8bIJ+Um14IDoPd1
         prUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678506087;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5NvXwZzaPCbq6uRhEkZ6ujOHeAaYaBBfV8EWkiAGW0E=;
        b=FTYgKWoDBsGwGAMZyReRhjQ7/NLA/gO7sfTXTJGnxyKYGGHYNU9xQsl3ZEtny3ciWg
         pLJK0USi02sgAqGuZz+fT4eVkAnKR9c1XsXAz4DenK5R3sBUtXVo4IBd9IC5R5iJsE8s
         ANCr5jayQxWty5HssBIjZArFX6gG2M8HJq5/ZF6p4GBxeqdionBilHbIlDM7GGd/SoHk
         YIQv4cXDoeDHMX47D95OKVUAKKUOutzyFtdxrk2zhsIFRvVIG6Z2suoaoSGKJfxkLeM5
         UqA/pMJjp9BafayD5ZBrQ6Yvx95WjkHncSqqEtOOHWzfJb81/ruPdIVZJwH6gO2eKNMv
         kmRA==
X-Gm-Message-State: AO0yUKWwja1lJtUy+lBvj0MADnKl4oSlshMlklP/VKnbNf82neqcmCYc
        ULaupYz1Lf+kyyZlFKi6ujHVDg==
X-Google-Smtp-Source: AK7set/FHsvyMOlrwinkP9JoEdpxa7FPhoLeB9ErhuXyyMkP4EB56+E+e2ziI9HLrFMrw3ACeWT74w==
X-Received: by 2002:a05:6a20:29a9:b0:cd:c79:514b with SMTP id f41-20020a056a2029a900b000cd0c79514bmr22813924pzh.2.1678506087442;
        Fri, 10 Mar 2023 19:41:27 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id b5-20020aa78105000000b005a90f2cce30sm509210pfi.49.2023.03.10.19.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 19:41:27 -0800 (PST)
Date:   Fri, 10 Mar 2023 19:41:25 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 0/5] net: Extend address label support
Message-ID: <20230310194125.33ca44d7@hermes.local>
In-Reply-To: <cover.1678448186.git.petrm@nvidia.com>
References: <cover.1678448186.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Mar 2023 12:44:53 +0100
Petr Machata <petrm@nvidia.com> wrote:

> IPv4 addresses can be tagged with label strings. Unlike IPv6 addrlabels,
> which are used for prioritization of IPv6 addresses, these "ip address
> labels" are simply tags that the userspace can assign to IP addresses
> arbitrarily.
> 
> IPv4 has had support for these tags since before Linux was tracked in GIT.
> However it has never been possible to change the label after it is once
> defined. This limits usefulness of this feature. A userspace that wants to
> change a label might drop and recreate the address, but that disrupts
> routing and is just impractical.
> 
> IPv6 addresses lack support for address labels (in the sense of address
> tags) altogether.
> 
> In this patchset, extend IPv4 to allow changing the label defined at an
> address (in patch #1). Then, in patches #2 and #3, extend IPv6 with a suite
> of address label operations fully analogous with those defined for IPv4.
> Then in patches #4 and #5 add selftest coverage for the feature.
> 
> An example session with the feature in action:
> 
> 	# ip address add dev d 2001:db8:1::1/64 label foo
> 	# ip address show dev d
> 	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
> 	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
> 	    inet6 2001:db8:1::1/64 scope global foo <--
> 	    valid_lft forever preferred_lft forever
> 	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
> 	    valid_lft forever preferred_lft forever
> 
> 	# ip address replace dev d 2001:db8:1::1/64 label bar
> 	# ip address show dev d
> 	4: d: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc [...]
> 	    link/ether 06:29:74:fd:1f:eb brd ff:ff:ff:ff:ff:ff
> 	    inet6 2001:db8:1::1/64 scope global bar <--
> 	    valid_lft forever preferred_lft forever
> 	    inet6 fe80::429:74ff:fefd:1feb/64 scope link d
> 	    valid_lft forever preferred_lft forever
> 
> 	# ip address del dev d 2001:db8:1::1/64 label foo
> 	RTNETLINK answers: Cannot assign requested address
> 	# ip address del dev d 2001:db8:1::1/64 label bar

This would add a lot of naming confusion with existing IPv6 address labels.
And MPLS labels.

See man ip-addrlabel for more info.  Can't think of better term for this.
Tag would raise conflicts with vlan/vxlan tag term.
Name would be confusing vs DNS naming.

Also, most of the real world manages addresses through automated services so
doing it with ip address isn't going to help.



