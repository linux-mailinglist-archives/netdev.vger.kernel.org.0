Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6464D5753
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 02:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345380AbiCKB14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 20:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345351AbiCKB1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 20:27:47 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3D919F466
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 17:26:45 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2dc348dab52so78386067b3.6
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 17:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KA9YZ/MGaQsalELOdrxAActwdu72Km42M2dgBlMQW0I=;
        b=i9IMsBytaLTTr9sYHJVkreJBtCBSxZ1iU0kTG+0wX2HudhdQ9bqjpr5r43jDwCKWYy
         DnJWHrt3lTbyvD26cdGAky0jqFf8LlNtf2/PNDTaftTL+aCZxxfgYAzBDp5dxLX7jkMb
         7s3YzmXn+matyTMkz6DcQ2nFzsNbzzK0I5cFPfB1Mtu3xnmg8Nd0tNX8ox99ofyOq3/2
         ME1fCdMn6mtI2yxDa1Bo8PU1Vug0eH5szAuk9w/xvwqD7dCxrBZSdlISGcufoHgLqzNd
         CNYkoD6Vykui2LhibXDH+06bzU/mRoFVHHu0tmSdO3KoygjMWJGjLXjf3gj28TrJSM2g
         Igcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KA9YZ/MGaQsalELOdrxAActwdu72Km42M2dgBlMQW0I=;
        b=daAMDRsz8+9/0uS71gCut7BjNHqVSoHNjB+DUuPkZDLpzuUYWQeDE7WzCgMEjC4xx7
         +5kMBEdyq+J5sp6KvO3HISqG7N7hafqob0sUelJ90Pxpar5olG2o5A+7EQaqTRewlgZx
         DJG7UZsOoXM74RN4k14pIcT19wPDpMkQtnouHVLofI1VMfNVCyOTPYaupOp07Wmb+ud2
         OQZ1/dJJbddd/WkDl7af7b7n0I5Rxg8bSKt6Y7o1Rrl+gyQs0uEEdvzw7JOLKagK/DXq
         2b3GN6zvb3+4V196AXufdJqYTzaC1W1aq2DYd9fnqrOC2BCuUVtJxLo5IvBUc1Nsewj1
         bvaw==
X-Gm-Message-State: AOAM531YMXEx+73BnGn5d/5UsCTU54ZzrMkk0587MmEhCat8Ysp1U3dI
        WiYeFT1o0+ZePwvbcpkT+8b2HOjUxNTFmeUe7hO+zg==
X-Google-Smtp-Source: ABdhPJxSofcm7lRCRp6xAfTgi9OIDSyZM9GgFv0Msotp0q/OKYFtxgvI7QElXdlaKgsrJFOXfsmpoTzWc9IAupp5Jeo=
X-Received: by 2002:a81:6357:0:b0:2d7:2af4:6e12 with SMTP id
 x84-20020a816357000000b002d72af46e12mr6679940ywb.317.1646962004594; Thu, 10
 Mar 2022 17:26:44 -0800 (PST)
MIME-Version: 1.0
References: <20220310135012.175219-1-jiyong@google.com> <20220310141420.lsdchdfcybzmdhnz@sgarzare-redhat>
 <20220310102636-mutt-send-email-mst@kernel.org> <20220310170853.0e07140f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310170853.0e07140f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jiyong Park <jiyong@google.com>
Date:   Fri, 11 Mar 2022 10:26:08 +0900
Message-ID: <CALeUXe7OGUUt+5hpiLcg=1vWsOWkSRLN3Lb-ncpXZZjsgZntjQ@mail.gmail.com>
Subject: Re: [PATCH v3] vsock: each transport cycles only on its own sockets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First of all, sorry for the stupid breakage I made in V2. I forgot to turn
CONFIG_VMWARE_VMCI_VSOCKETS on when I did the build by
myself. I turned it on later and fixed the build error in V3.

> Jiyong, would you mind collecting the tags from Stefano and Michael
> and reposting? I fixed our build bot, it should build test the patch
> - I can't re-run on an already ignored patch, sadly.

Jakub, please bear with me; Could you explain what you exactly want
me to do? I'm new to kernel development and don't know how changes
which Stefano and Machael maintain get tested and staged.
