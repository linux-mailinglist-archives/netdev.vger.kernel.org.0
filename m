Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6155B6ED37A
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 19:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbjDXR1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 13:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjDXR1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 13:27:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA3C8FC;
        Mon, 24 Apr 2023 10:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=mdZMqXmTjXshW4E/eEgL1QKpY1NylxDe1EMTOVylnec=;
        t=1682357231; x=1683566831; b=a+PYMYR9pAvR9UOUYkoyPBdh3x+hKv1pVNe2riawuZomjz5
        IqTjOiy0ffA0nc4sWnAO16aaF/Nswxlsvh2M6MDL6K2h+W+CmXLO9tG+/wAgeAsQ/uVtj/h2fC3fm
        /xoN1qUjxLmmeMywFDNNVY4PebuzcWeDwES0rWacQD4syZ7Ge/ZxQvDRGCRzWd1/fjhB+LdKiOXwb
        guxJdySVUMdSOMpdMYQyoxufJOKsb71P76CAe0UY77KkrcJDQHLl8QFHu8+uv8TZR/JHbilNklSCK
        icbSB0DiZzed7HrCgWyQ1KeipNPqd8C9U/BewYGZddJiN6Ub6hkXQpoSBmvhJ+TA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pqzy1-007KKJ-1A;
        Mon, 24 Apr 2023 19:27:09 +0200
Message-ID: <017c5178594e2df6ca02f2d7ffa9109755315c56.camel@sipsolutions.net>
Subject: Re: [PATCH RFC v1 1/1] net: mac80211: fortify the spinlock against
 deadlock in interrupt
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Wetzel <alexander@wetzel-home.de>
Date:   Mon, 24 Apr 2023 19:27:08 +0200
In-Reply-To: <20230423082403.49143-1-mirsad.todorovac@alu.unizg.hr>
References: <20230423082403.49143-1-mirsad.todorovac@alu.unizg.hr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2023-04-23 at 10:24 +0200, Mirsad Goran Todorovac wrote:
> In the function ieee80211_tx_dequeue() there is a locking sequence:
>=20
> begin:
> 	spin_lock(&local->queue_stop_reason_lock);
> 	q_stopped =3D local->queue_stop_reasons[q];
> 	spin_unlock(&local->queue_stop_reason_lock);
>=20
> However small the chance (increased by ftracetest), an asynchronous
> interrupt can occur in between of spin_lock() and spin_unlock(),
> and the interrupt routine will attempt to lock the same
> &local->queue_stop_reason_lock again.
>=20
> This is the only remaining spin_lock() on local->queue_stop_reason_lock
> that did not disable interrupts and could have possibly caused the deadlo=
ck
> on the same CPU (core).
>=20
> This will cause a costly reset of the CPU and wifi device or an
> altogether hang in the single CPU and single core scenario.
>=20
> This is the probable reproduce of the deadlock:
>=20
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:  Possible unsafe locking =
scenario:
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        CPU0
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:        ----
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   lock(&local->queue_stop=
_reason_lock);
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:   <Interrupt>
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:     lock(&local->queue_st=
op_reason_lock);
> Apr 10 00:58:33 marvin-IdeaPad-3-15ITL6 kernel:
>                                                  *** DEADLOCK ***
>=20
> Fixes: 4444bc2116ae

That fixes tag is wrong, should be

Fixes: 4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")

Otherwise seems fine to me, submit it properly?

johannes

