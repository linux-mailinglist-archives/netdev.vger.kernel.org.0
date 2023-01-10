Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9281664547
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjAJPuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:50:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbjAJPtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:49:53 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6C147330
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:49:52 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id d15so13603603pls.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AGLhc860C2uHFLWsYEpWCw3VdH6TGK2wG/L5398V7/o=;
        b=dHShp9Mn8XkxEJfYyzFvg8VGGFdNHYkP3/w8kFaNex4AhSpSSueMAAXbfTRNPHg8+F
         ZLn8485Mrn9D9bSvYf0vo3sjJiZ5X61p/0uQUf8pd2thzBEX9k1NcaX/a3u3C/KpqEQb
         SCgobnw3L7YhTCnPNGP9bgnWT/iojLfpZ3DOJowCpDcyJFKWHm62GTLY2aboBhOuKhWC
         ualA3boJw5mnnk89+fCN2Tv6OsHSWe/anU2jJ+IJtFYTP+Lepkip4oqF/OYz9r46HZ5L
         v5BDre6dpncSFf6xK+JutQByYFCw/oNfDMDebtFwp/uK8b3b1TUp49ZsptINjxB718Jp
         xNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AGLhc860C2uHFLWsYEpWCw3VdH6TGK2wG/L5398V7/o=;
        b=dxoR1eiuGfYOob2gMIKY26fc8eHhX9PdqOJLY2mNYQZvfpjfffpkUJ7zFAT7pJ0szA
         QbGe7BUe47B7b/M53iYzifG21UCGhYNAgajQ6w1TnIGdiS3awfg/yk6WHNv9Q485OsEg
         bZ3gcZicSWCmI7GFYCInEKV+t6Y0t6gpm5ezBfoUU6kFgmo82ERcHi5M/KiGcUFY+rqx
         Hq8w493xBw/IRXM5FLTewO44xtKYq7yRL9e+/aYnF5tVsh51mxAq3LlBRfdU5s3nDVKb
         2XbYNmckDNUnKlS/blzMPeC1XVhkOqNiX4DqZ6OYYFUBi+iaMlPp9kg3cXsbZu3ne0Ya
         ZKKw==
X-Gm-Message-State: AFqh2krs6Bv1Zov6Akte2r3A7R9DXxRJGG868V/i9rnNNgAfaN9HKuv9
        4gtYKmLd6DxERFfn2gzDW6w=
X-Google-Smtp-Source: AMrXdXsovCFSuQrK6l9U1U2Pyg2UrcCIY/EztK3F6dEnaNrXgzjKjSlYlICzN0aczAvuVny8Jml/QA==
X-Received: by 2002:a17:90b:3c10:b0:225:db2e:b1a5 with SMTP id pb16-20020a17090b3c1000b00225db2eb1a5mr57622157pjb.14.1673365791787;
        Tue, 10 Jan 2023 07:49:51 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b001fde655225fsm2704604pjb.2.2023.01.10.07.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 07:49:51 -0800 (PST)
Message-ID: <f4c818ba6cb5ac6f34bd73a67b18c5cd9da5f42a.camel@gmail.com>
Subject: Re: [PATCH net-next v4 01/10] tsnep: Use spin_lock_bh for TX
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 07:49:50 -0800
In-Reply-To: <20230109191523.12070-2-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-2-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> TX processing is done only within BH context. Therefore, _irqsafe
> variant is not necessary.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

Rather than reducing the context of this why not drop it completely? It
doesn't look like you are running with the NETIF_F_LLTX flag set so
from what I can tell it looks like you are taking the Tx lock in the
xmit path. So Tx queues are protected with the Tx queue lock at the
netdev level via the HARD_TX_LOCK macro.

Since it is already being used in the Tx path to protect multiple
access you could probably just look at getting rid of it entirely.

The only caveat you would need to watch out for is a race between the
cleaning and transmitting which can be addressed via a few barriers
like what was done in the intel drivers via something like the
__ixgbe_maybe_stop_tx function and the logic to wake the queue in the
clean function.

Alternatively if you really feel you need this in the non-xmit path
functions you could just drop the lock and instead use __netif_tx_lock
for those spots that are accessing the queue outside the normal
transmit path.
