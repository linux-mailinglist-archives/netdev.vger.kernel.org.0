Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C873E664590
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233842AbjAJQFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238582AbjAJQFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:05:12 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82960C4A
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:05:10 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso16984401pjp.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yOWnsj5Sbxx+WZxZqqeHFNQfKLnc5E/eO6CIGmof80Q=;
        b=eLoxpPHzLxRzaC0Scq0tNiwh2pqQE8aMnQNRzgKWstQGOcM/+BTRSA4CCdTCI/16mN
         k63fSdfwL3EcBr5U+JBz+d0ZYEGjjE7O3tyYxL9BG7nlX2nLDLKU4dvhq04z/Q+ssDt/
         YgM9W0xZUagdf3Y3RDun+1W679kH6YopXWx2o8/xnohvpbZrEOObeiWgds7UW+9qPvAI
         dk882Uy4mtZyUXomNTZkWV++iPU9V+01Xfo0HhaCGzLJ/dy4RZAV89WU3I2wdiNNFy9Y
         q61yX3zdLtIHuCm8C3ZunWdE8mup52Pmf0MN3vkFgaDYeAx3dZaA6YfRAcxeZLEchcPu
         RpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yOWnsj5Sbxx+WZxZqqeHFNQfKLnc5E/eO6CIGmof80Q=;
        b=RRJjUr5lV7I/tHVXEQNma+lELahVsLuOMAFr5v1NpafP0UNoN43xmqfZtV+H4/yj4Z
         kvbM5mP2dGdlWJU87CxJSyJ3nqeZR8FWWd/h9HH+wBJpgPwnQrHJ4KxvZFjMWZgONi53
         Eoyr7G9l324OCSEzR+sOF9X1LIBtTAPxd3AV5Jm9gPtVJULT15xHrPCRdhk6K4sg8bUs
         gsSiN5V092vnKsP7QRZTj09++YvNG8si9th1j4OJFByHBS+EcSiu+59qGUnJIgCnsyEw
         g6ueAya7oEQ+V+4N8MHixx9gEVK3dNBMqVXoRxcqssCJ7TcCNTo9PMCypMX9Gra4dadH
         cf6A==
X-Gm-Message-State: AFqh2krdahvbxkONMMA8YWwV3teII2HP+PHOwQQaAHFQHxeru1Giqu16
        HDDmx+57Q0SZAvkUY0AN/WY=
X-Google-Smtp-Source: AMrXdXu6Af1RVu4HH/ZCnT7TEHtn78eXp4jDA+UygG9rwhILrv8qdh4Bb2bdht7VGjDsSNKYhI2vhg==
X-Received: by 2002:a05:6a20:959b:b0:a5:7e02:4e0 with SMTP id iu27-20020a056a20959b00b000a57e0204e0mr106371299pzb.3.1673366709841;
        Tue, 10 Jan 2023 08:05:09 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id u7-20020a17090341c700b00186c3afb49esm8267726ple.209.2023.01.10.08.05.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:05:09 -0800 (PST)
Message-ID: <aeceda3aee89ad7e856afa45f78d482b3c490cc4.camel@gmail.com>
Subject: Re: [PATCH net-next v4 04/10] tsnep: Add adapter down state
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 08:05:08 -0800
In-Reply-To: <20230109191523.12070-5-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-5-gerhard@engleder-embedded.com>
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
> Add adapter state with flag for down state. This flag will be used by
> the XDP TX path to deny TX if adapter is down.
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

What value is this bit adding?

From what I can tell you could probably just use netif_carrier_ok in
place of this and actually get better coverage in terms of identifying
state in which the Tx queue is able to function. So in your XDP_TX
patch you could do that if you really need it.=20

As far as the use in your close function it is redundant since the
IFF_UP is only set if ndo_open completes, and ndo_stop is only called
if IFF_UP is set. So your down flag would be redundant with !IFF_UP in
that case.

