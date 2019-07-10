Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D087B649C7
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 17:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfGJPhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 11:37:13 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:36168 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfGJPhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 11:37:12 -0400
Received: by mail-wr1-f47.google.com with SMTP id n4so2984110wrs.3
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 08:37:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=w6gOM0EF8w6OgRkN0S1HwMV2ZTxvl6sDwbz7UvtM7Ds=;
        b=JiOXQ/rctKhfa2fGHHzHGDKiDaWos3kjLiWPulrHNcXoIjan+KHESQ/264wzDlB92O
         p06DeAEovfE0z372C9QM7NbzoQKmZDKY7a61dpz2JeNFpCmupEilD3ewhjluDOS4w7c3
         ZBVD35Qo+mzpUQ0uoJV1iPuFobSvFznXPVhGfn8ViUEw5o8oczRL0C7bFNn5XcAj45H0
         yvm03BX8gpcON8CYumjrE3bAWnGbJEIJzSblAahk+G9a7/6I2QkpmvSR0wrfd19mpFKD
         00zGSec0Es3blIavr/2iY+t5o1xikA+coI2u+D2hRRDKz2QTF8+kMJcZxXVoa7e9Hhwa
         GwgA==
X-Gm-Message-State: APjAAAUFCIuaKJAp86NwdoL1DB5E/gSmASTAnsAK9/Q1z4ky390eF7Du
        bt9rwuWK4C+TURLdHj1Cxe2y3g==
X-Google-Smtp-Source: APXvYqw5KGnsPShaRheRWeLkyw7iNHfzH6H8mZGknsxq9TfA80oFKuQNpokcGJJXQu9Hu6et/y/htg==
X-Received: by 2002:a5d:468a:: with SMTP id u10mr32491868wrq.177.1562773029910;
        Wed, 10 Jul 2019 08:37:09 -0700 (PDT)
Received: from steredhat (host122-201-dynamic.13-79-r.retail.telecomitalia.it. [79.13.201.122])
        by smtp.gmail.com with ESMTPSA id 15sm1847474wmk.34.2019.07.10.08.37.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 08:37:09 -0700 (PDT)
Date:   Wed, 10 Jul 2019 17:37:07 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [RFC] virtio-net: share receive_*() and add_recvbuf_*() with
 virtio-vsock
Message-ID: <20190710153707.twmzgmwqqw3pstos@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
as Jason suggested some months ago, I looked better at the virtio-net driver to
understand if we can reuse some parts also in the virtio-vsock driver, since we
have similar challenges (mergeable buffers, page allocation, small
packets, etc.).

Initially, I would add the skbuff in the virtio-vsock in order to re-use
receive_*() functions.
Then I would move receive_[small, big, mergeable]() and
add_recvbuf_[small, big, mergeable]() outside of virtio-net driver, in order to
call them also from virtio-vsock. I need to do some refactoring (e.g. leave the
XDP part on the virtio-net driver), but I think it is feasible.

The idea is to create a virtio-skb.[h,c] where put these functions and a new
object where stores some attributes needed (e.g. hdr_len ) and status (e.g.
some fields of struct receive_queue). This is an idea of virtio-skb.h that
I have in mind:
    struct virtskb;

    struct sk_buff *virtskb_receive_small(struct virtskb *vs, ...);
    struct sk_buff *virtskb_receive_big(struct virtskb *vs, ...);
    struct sk_buff *virtskb_receive_mergeable(struct virtskb *vs, ...);

    int virtskb_add_recvbuf_small(struct virtskb*vs, ...);
    int virtskb_add_recvbuf_big(struct virtskb *vs, ...);
    int virtskb_add_recvbuf_mergeable(struct virtskb *vs, ...);

For the Guest->Host path it should be easier, so maybe I can add a
"virtskb_send(struct virtskb *vs, struct sk_buff *skb)" with a part of the code
of xmit_skb().

Let me know if you have in mind better names or if I should put these function
in another place.

I would like to leave the control part completely separate, so, for example,
the two drivers will negotiate the features independently and they will call
the right virtskb_receive_*() function based on the negotiation.

I already started to work on it, but before to do more steps and send an RFC
patch, I would like to hear your opinion.
Do you think that makes sense?
Do you see any issue or a better solution?

Thanks in advance,
Stefano
