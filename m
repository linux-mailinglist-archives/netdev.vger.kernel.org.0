Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1962A335
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 21:42:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiKOUmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiKOUmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 15:42:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F33913EBD
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668544861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5/NB4n5pjIOWLCWn4EONkdNZMDtYpREKPxU/8nqSVRs=;
        b=PFsF2BuaAeAiYY4a+XmR9ojWYXaBN6IfSuoLVwB/yfy6TR3Ceo2b2nNKXZUxT6aBl5eXnp
        wDlAjjAO0Z9Q6a1M+fMlAZlsJY79Zkf+TDr8N6Fi8wXqe5akpvmw93NttenA6mgFqLg/x2
        LOZJZWaNRvOxnkQSTLYKXkXQt0M4v08=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644-UUVV1wyhP8C2KUbLEarFaA-1; Tue, 15 Nov 2022 15:41:00 -0500
X-MC-Unique: UUVV1wyhP8C2KUbLEarFaA-1
Received: by mail-qk1-f199.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso15003313qkp.21
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:41:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5/NB4n5pjIOWLCWn4EONkdNZMDtYpREKPxU/8nqSVRs=;
        b=1D09yxhYF6MdTRFY0I3y7s9Bs8EYv/2c5GSnhfqhbGl3syXL8lmo/LxUwGKRVyzsi2
         ZOylmuRuI6JYm0s0fQBFWcUd/2xSL2IOGvp4X6QHd4y6EljJZGIRyHmkIKL4v2t9yESF
         543uz3KjPeQUqrOWjIHk1mthS3PyDA1K/RGEEO8g2AhKQonWROBxDweUaOpK3xFIit44
         oFYsdKaj57K0iaC1FEXrfzKuz9jqUL5nT/iwxRedEOgFGfllGZyUGusBf1m9uj8ytbAH
         RutJsd7yuSG+LIj08Jwii7cpEP9Jd4LYx5W0ypl2ohxton1MqCg4u/hlaE+Oxj0rCBv5
         3lMA==
X-Gm-Message-State: ANoB5plXjyJShLP+LY9TRUuektzkpPr8Ihx4HH6+KjzRb+zdpnMfyhRV
        suBsO/ZHwm3KRxYdWDYLj32Zu5YP7RoS2Jq7KDKfZCyc9oz+C6LLaj98hV03oCNoPqse4MZcXS0
        EXYn5iHlDS2YEHH1+
X-Received: by 2002:a05:622a:5c9b:b0:39c:cb9e:3524 with SMTP id ge27-20020a05622a5c9b00b0039ccb9e3524mr18022003qtb.563.1668544859590;
        Tue, 15 Nov 2022 12:40:59 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4YOyLcXMm3PjCpLco97NLrXzrnIuOiZV4RDwimWi0e7yPD3Ah2WPiXe9MJ4ACF9jxEfz22nw==
X-Received: by 2002:a05:622a:5c9b:b0:39c:cb9e:3524 with SMTP id ge27-20020a05622a5c9b00b0039ccb9e3524mr18021978qtb.563.1668544859332;
        Tue, 15 Nov 2022 12:40:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id s8-20020a05620a254800b006fa16fe93bbsm8802156qko.15.2022.11.15.12.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 12:40:58 -0800 (PST)
Message-ID: <4b84f8ac08cf5d4037bdfefc1927cd05db09804b.camel@redhat.com>
Subject: Re: [PATCH net-next 7/7] selftests: add a selftest for sctp vrf
From:   Paolo Abeni <pabeni@redhat.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Date:   Tue, 15 Nov 2022 21:40:53 +0100
In-Reply-To: <CADvbK_eEkE04vC1v-zuD2x6CMtvBmV2HZxPKfAwsF4N0eUi4=g@mail.gmail.com>
References: <cover.1668357542.git.lucien.xin@gmail.com>
         <39a981bc89921aedbff46f9d1e42369e93416d1d.1668357542.git.lucien.xin@gmail.com>
         <49285c832b6ea6fc36eea946206c53cb3c0aea87.camel@redhat.com>
         <CADvbK_eEkE04vC1v-zuD2x6CMtvBmV2HZxPKfAwsF4N0eUi4=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-11-15 at 10:33 -0500, Xin Long wrote:
> On Tue, Nov 15, 2022 at 5:29 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > On Sun, 2022-11-13 at 11:44 -0500, Xin Long wrote:
> > 
> > > +testup() {
> > > +     ip netns exec $SERVER_NS sysctl -w net.sctp.l3mdev_accept=1 2>&1 >/dev/null
> > > +     echo -n "TEST 01: nobind, connect from client 1, l3mdev_accept=1, Y "
> > > +     do_test $CLIENT_NS1 || { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 02: nobind, connect from client 2, l3mdev_accept=1, N "
> > > +     do_test $CLIENT_NS2 && { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     ip netns exec $SERVER_NS sysctl -w net.sctp.l3mdev_accept=0 2>&1 >/dev/null
> > > +     echo -n "TEST 03: nobind, connect from client 1, l3mdev_accept=0, N "
> > > +     do_test $CLIENT_NS1 && { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 04: nobind, connect from client 2, l3mdev_accept=0, N "
> > > +     do_test $CLIENT_NS2 && { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 05: bind veth2 in server, connect from client 1, N "
> > > +     do_test $CLIENT_NS1 veth2 && { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 06: bind veth1 in server, connect from client 1, Y "
> > > +     do_test $CLIENT_NS1 veth1 || { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 07: bind vrf-1 in server, connect from client 1, Y "
> > > +     do_test $CLIENT_NS1 vrf-1 || { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 08: bind vrf-2 in server, connect from client 1, N "
> > > +     do_test $CLIENT_NS1 vrf-2 && { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 09: bind vrf-2 in server, connect from client 2, Y "
> > > +     do_test $CLIENT_NS2 vrf-2 || { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 10: bind vrf-1 in server, connect from client 2, N "
> > > +     do_test $CLIENT_NS2 vrf-1 && { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 11: bind vrf-1 & 2 in server, connect from client 1 & 2, Y "
> > > +     do_testx vrf-1 vrf-2 || { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +
> > > +     echo -n "TEST 12: bind vrf-2 & 1 in server, connect from client 1 & 2, N "
> > > +     do_testx vrf-2 vrf-1 || { echo "[FAIL]"; return 1; }
> > > +     echo "[PASS]"
> > > +}
> > > +
> > > +trap cleanup EXIT
> > > +setup || exit $?
> > > +echo "Testing For SCTP VRF:"
> > > +CLIENT_IP=$CLIENT_IP4 SERVER_IP=$SERVER_IP4 AF="-4" testup && echo "***v4 Tests Done***" &&
> > > +CLIENT_IP=$CLIENT_IP6 SERVER_IP=$SERVER_IP6 AF="-6" testup && echo "***v6 Tests Done***"
> > 
> > To properly integrate with the self-test suite, you need to ensure that
> > the script exits with an error code in case of failure, e.g. storing
> > the error in a global variable 'ret' and adding a final:
> > 
> > exit $ret
> the above lines are equal to "exit $ret".
> the exit code in testup() will return if it's not 0.
> Do you mean I should make it more clear?

I admit I initially did not notice that the posted code is equivalent
to

exit $ret

so perhaps make it more explicit could help :) Not a big deal anyway.

Thanks,

Paolo

