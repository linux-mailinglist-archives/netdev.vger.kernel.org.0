Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FFE6C7F2E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 14:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjCXN6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 09:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbjCXN6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 09:58:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6381E15CB1
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 06:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679666231;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xvcJNrPQD5ooFYZurkB3yN9PFKDKP+vxBqfGV/npfuk=;
        b=RSfMyDezSott8s1wkJWliTGwaB9MW4aIrfZWJ7OpxcwKNuppvBzsmq5gqN2kbDpWPRuHpd
        6+4ftO4S5D0Qi4EDADJQ6iJb1bft9V7BBloz3o6HpzNYoV5+pGTHcjzCDhrY/Hp9sv5kTa
        qPiDoLH77vz4ptMjOUwtxVQkGdN0IIs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-czSmQxgzPz28tlR_y-YdUw-1; Fri, 24 Mar 2023 09:57:10 -0400
X-MC-Unique: czSmQxgzPz28tlR_y-YdUw-1
Received: by mail-ed1-f69.google.com with SMTP id f15-20020a50a6cf000000b0050050d2326aso3247208edc.18
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 06:57:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679666229;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvcJNrPQD5ooFYZurkB3yN9PFKDKP+vxBqfGV/npfuk=;
        b=Azx4i5VmH9HYFvAX+tMKkP5eb8WznabAj6PeW8By7TIS5tciHhpcF4TVjcBsrwf8Ea
         fCWlU4yQ6KJM7CKOr9rR4IGnqeFRJYgFCyT2q7rFcmTlo3X6TuYuQkg4CJXLFKvFBEnS
         uqfuH0ypDn6HRoY+nj9F5tmw+SaNCLfmz9h56/Pqbq+j9ZOLMWZzBAncfgSB5OV15WvP
         17ChtIttbV+UlInO/zzrIKPd1FDQyHtAnxXRITl6cdRR1BbWmvksy47i1PIpRaqkKr7h
         /jMla4LONfZBYZPLo3q9vla4+1QJCw1WIH2NZeEju/mvcj//ekwlFD2hKZaec+HPPhfF
         ZGzA==
X-Gm-Message-State: AAQBX9f3QCFgFdfn1ZZ3GKUxa24AMa9eYqXxam3GqEVUZuHrmRcMKkbb
        cUD+Ab7qG0wk1J8sbid5EdNUosYzFzosiADVpVpV54oLZP0uULCuENospWWbtFxTaMQgHOQ6uWe
        HDKOlU5eJ/YYjKhaNGCYcCom98L+VfI5r
X-Received: by 2002:a50:f69e:0:b0:4fc:8749:cd77 with SMTP id d30-20020a50f69e000000b004fc8749cd77mr1542604edn.3.1679666229223;
        Fri, 24 Mar 2023 06:57:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350bigzFWO3HLR1wBXdAmOWSmDdssXZvyhIoU+omNqJjNe4otSNeDTt3p1Ckx8dJADayo4lhlv4HE3l9QBDb44aI=
X-Received: by 2002:a50:f69e:0:b0:4fc:8749:cd77 with SMTP id
 d30-20020a50f69e000000b004fc8749cd77mr1542584edn.3.1679666229026; Fri, 24 Mar
 2023 06:57:09 -0700 (PDT)
MIME-Version: 1.0
References: <20230324110558.90707-1-miquel.raynal@bootlin.com>
In-Reply-To: <20230324110558.90707-1-miquel.raynal@bootlin.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Fri, 24 Mar 2023 09:56:57 -0400
Message-ID: <CAK-6q+gzwOFbpN4JfYdfUzmVfeF+YzNwamkEaF-gYeMY8bzNww@mail.gmail.com>
Subject: Re: [PATCH wpan-next 0/2] ieee802154: Handle imited devices
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 24, 2023 at 7:07=E2=80=AFAM Miquel Raynal <miquel.raynal@bootli=
n.com> wrote:
>
> As rightly pointed out by Alexander a few months ago, ca8210 devices
> will not support sending frames which are not pure datagrams (hardMAC
> wired to the softMAC layer). In order to not confuse users and clarify
> that scanning and beaconing is not supported on these devices, let's add
> a flag to prevent them to be used with the new APIs.
>

Acked-by: Alexander Aring <aahringo@redhat.com>

I appreciate that you care about driver specific quirks which need to
be done here. The users of this driver are getting aware now there is
a lack of support here.

Thanks.

- Alex

