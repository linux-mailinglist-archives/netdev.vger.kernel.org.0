Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F096CFA01
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbjC3EMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjC3EMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:12:50 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C415245
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:12:48 -0700 (PDT)
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 444B33F233
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680149567;
        bh=DR1COB211VULqOsnLvzIzPAA50vnM9pmd3L7C7a2Hig=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=cBmv1c3BwZXZkT/ayxI07CnUKzufS9jxeKtxxeMf/IREkRVaFQXwcvtgWxCX5gFon
         50YwBwTCuU3BZyNKbTLLiVIs6O3KzVws8Jc4B1uS/ULHjNBwsbNjqBL+QsLvGOg8V/
         Qe3Q/w80lS3GHEROY/2lbH0C6ECXeW+3Oeu1Kr2GTHLST1VAONTTsj8oQFfdLr6jyZ
         np07r0ntS2iDW8Lk2cx5k+d6lAGIO2UGip3vTeaOnrIJKVPxetEPsjhKcqNXspzNR5
         IwwNSsU9K80BcoOcazIQZ5CGd5Hqae+MgtrbMG4cYccw9W6oN26BB9bVL5FzsDHiNN
         xexk30I01QuNw==
Received: by mail-pl1-f199.google.com with SMTP id c8-20020a170902d48800b001a1e0fd4085so10730912plg.20
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680149565;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DR1COB211VULqOsnLvzIzPAA50vnM9pmd3L7C7a2Hig=;
        b=GZNvIMQ7l3vm7EVEuL9OvxFU4YdfIzhgiaRMiyhkeOc9dTfQpinzfOaIvr/nE9ThWO
         p0ShNr6Fy+k5IODau/G1kRPHCU3fOq7Vso+JEsCw2PnnRMybhcl66z0guYDI2w2R+VOg
         nCAqib69d5BOdnV178QVaBjGVmVR/M47JaWIAwMZATEoOoShaKTWDy8EFFEFxvcA0/BB
         xee+zPvrFQo2yA+Ds9CM2N2oqdxFC49WqffYNGWs8seTAAWhu093NWCg1uVxQFo38a+m
         FM/T9GHvf40NJiNJGm75uzlZlsdHGnh++565bQRNki97D65bQQ6MCysGsa8Prb5ZucTO
         T1/Q==
X-Gm-Message-State: AO0yUKV8loCudgCKysltM2EI4u/sMr9g5MNwGSMiAcC0CfKebMrcQHeO
        4zaWuo7QuzYXCQ3of/ZKpKZgx+gh21B0R9/iL4BytSxkxZZexp9NZtRUjEsvUzMEGe7/Ahm0Q4W
        6rDz5HjLvpD5BDT/oRctMbdchjI2YhPUGKw==
X-Received: by 2002:a05:6a20:c125:b0:d9:c3f5:292c with SMTP id bh37-20020a056a20c12500b000d9c3f5292cmr17661599pzb.37.1680149565414;
        Wed, 29 Mar 2023 21:12:45 -0700 (PDT)
X-Google-Smtp-Source: AK7set87sai4PGKj76b6KhRVjj7YstzEHUUnXGqvbDk2v1VrgpM3BS4FcVlk94qPModgKJlYIXStLQ==
X-Received: by 2002:a05:6a20:c125:b0:d9:c3f5:292c with SMTP id bh37-20020a056a20c12500b000d9c3f5292cmr17661574pzb.37.1680149564987;
        Wed, 29 Mar 2023 21:12:44 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id r10-20020a63d90a000000b004fbe302b3f6sm22525592pgg.74.2023.03.29.21.12.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Mar 2023 21:12:44 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id 0F98860DBD; Wed, 29 Mar 2023 21:12:44 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 087F89FB79;
        Wed, 29 Mar 2023 21:12:44 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
cc:     Miroslav Lichvar <mlichvar@redhat.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] bonding: add software timestamping support
In-reply-to: <ZCUDFyNQoulZRsRQ@Laptop-X1>
References: <20230329031337.3444547-1-liuhangbin@gmail.com> <ZCQSf6Sc8A8E9ERN@localhost> <ZCUDFyNQoulZRsRQ@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 30 Mar 2023 11:33:43 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7143.1680149563.1@famine>
Content-Transfer-Encoding: quoted-printable
Date:   Wed, 29 Mar 2023 21:12:44 -0700
Message-ID: <7144.1680149564@famine>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu <liuhangbin@gmail.com> wrote:

>On Wed, Mar 29, 2023 at 12:27:11PM +0200, Miroslav Lichvar wrote:
>> On Wed, Mar 29, 2023 at 11:13:37AM +0800, Hangbin Liu wrote:
>> > At present, bonding attempts to obtain the timestamp (ts) information=
 of
>> > the active slave. However, this feature is only available for mode 1,=
 5,
>> > and 6. For other modes, bonding doesn't even provide support for soft=
ware
>> > timestamping. To address this issue, let's call ethtool_op_get_ts_inf=
o
>> > when there is no primary active slave. This will enable the use of so=
ftware
>> > timestamping for the bonding interface.
>> =

>> Would it make sense to check if all devices in the bond support
>> SOF_TIMESTAMPING_TX_SOFTWARE before returning it for the bond?
>> Applications might expect that a SW TX timestamp will be always
>> provided if the capability is reported.
>
>In my understanding this is a software feature, no need for hardware supp=
ort.
>In __sock_tx_timestamp() it will set skb tx_flags when we have
>SOF_TIMESTAMPING_TX_SOFTWARE flag. Do I understand wrong?

	Right, but the network device driver is required to call
skb_tx_timestamp() in order to record the actual timestamp for the
software timestamping case.

	Do all drivers that may be members of a bond return
SOF_TIMESTAMPING_TX_SOFTWARE to .get_ts_info and properly call
skb_tx_timestamp()?  I.e., is this something that needs to be checked,
or is it safe to assume it's always true?

	If I'm reading things correctly, the answer is no, as one
exception appears to be IPOIB, which doesn't define .get_ts_info that I
can find, and does not call skb_tx_timestamp() in ipoib_start_xmit().

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
