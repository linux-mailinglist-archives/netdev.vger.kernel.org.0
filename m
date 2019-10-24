Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390D0E3943
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 19:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410202AbfJXRFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 13:05:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50140 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2410141AbfJXRFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 13:05:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571936720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=03+5VBqCPd68lTAQRb1/kJfIJ/zUP3/Day5xyJuYTDk=;
        b=b5dnk9uwGgi0rz+jo0IlGSqtTAqIujA1FLKcF19r2f/Inkygp/tEocCS760wqvdr8dLdcK
        N5HlDVck8iUnXRtI8iILNPBPi5JmUUlP43AKgZDgoAV/cJtjsDHldN3MA/b49+m43pONsg
        DI2or6DgKmuGUjS+ngBmNZFNegjROj8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-L7hT95msMd6w09dT8Ve2hA-1; Thu, 24 Oct 2019 13:05:18 -0400
Received: by mail-lj1-f199.google.com with SMTP id 205so4127875ljf.13
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 10:05:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j/o8TfhScpVV/SFKEy17AB1Zf2axWbjJiCRdK+oaodM=;
        b=VGBNHFIiCh6mge9Ykh1bf8z9mTJL414dW1mctiBOrVOVTnbTnP3xiqRAGAdRNuWJ0P
         SijakGfLI0qp7d/5egiuhCCmg9wDBJXAN98tx5AVviuijEFuu5C0uUoksckXQWj/hCgs
         9wqKqHRf8Nkk9bi0TetcmgLEoWMPg9AUUl7UbzX34Dt9ae8LY6Y7wiFe2CkPlJ7K94nR
         YcvTaWZnzKjMAJMs0lDMURqEY8eM3dQxkIUdbJGx/9Epdgv1lzU9xcPtlH5CoVfEz376
         AEjO2nEjwsxS6Z7n84/bJFETHdZBcCMe5QuLQ5TqcCgfhYUCBZ98lTsLkTnxSHp2f+iM
         +j8w==
X-Gm-Message-State: APjAAAXNCXBi36LYQ8/n011CuDvmQBlKiGViZQiuQffEw+hS8BVYNp7Z
        vrpMdtfOHJ+MckNDQmU+6J5rkuD7bGT7gsYruMuprMe73fb6jOHO4nWy7hHFBRy8ZlCZyK88W5Q
        LJqMm7pAbQI3TNtg/Ejmz0EbaUoFUNZPJ
X-Received: by 2002:a05:6512:51a:: with SMTP id o26mr3538273lfb.132.1571936717133;
        Thu, 24 Oct 2019 10:05:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzIPhBNg98lecbpGanzXdv/jvDEOMcLhjDgpSTFOb/kzuzr1Y8DKoHvodVSYY7pWM8MkSV9AFU5hw5SZdcroyw=
X-Received: by 2002:a05:6512:51a:: with SMTP id o26mr3538262lfb.132.1571936716917;
 Thu, 24 Oct 2019 10:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191022141438.22002-1-mcroce@redhat.com> <20191023.202813.607713311547571229.davem@davemloft.net>
In-Reply-To: <20191023.202813.607713311547571229.davem@davemloft.net>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Thu, 24 Oct 2019 19:04:40 +0200
Message-ID: <CAGnkfhwbuXS7hYWuBqERi-FA1ZbjFqWN81aOP_MpcqsmPkkLVQ@mail.gmail.com>
Subject: Re: [PATCH net-next] mvpp2: prefetch frame header
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Stefan Chulski <stefanc@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>
X-MC-Unique: L7hT95msMd6w09dT8Ve2hA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 5:28 AM David Miller <davem@davemloft.net> wrote:
> You cannot unmap it this early, because of all of the err_drop_frame
> code paths that might be taken next.  The DMA mapping must stay in place
> in those cases.

Thanks for noting this.
I'm sending a series with this and other small fixes.

Regards,
--=20
Matteo Croce
per aspera ad upstream

