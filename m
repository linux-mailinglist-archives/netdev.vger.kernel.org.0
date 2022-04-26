Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1F850EF38
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 05:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243029AbiDZDdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 23:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240121AbiDZDda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 23:33:30 -0400
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF231172;
        Mon, 25 Apr 2022 20:30:16 -0700 (PDT)
Received: from [172.16.69.231] (unknown [49.255.141.98])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 1EF8420162;
        Tue, 26 Apr 2022 11:30:08 +0800 (AWST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=codeconstruct.com.au; s=2022a; t=1650943811;
        bh=f1PVLbmLqz5IPQlx+FIi6pDmg09DbyV9nrjE0q+JCFM=;
        h=Subject:From:To:Date:In-Reply-To:References;
        b=VmMAdQx3aKyfOY+rj6g1bhRIBzKmKepQiEuQbMLFkWU8kPP/MfSTmHXV6GkUl7c3u
         +kS8whk3b0qv3pNUO/ZfmjXPLOdK5VtZ5LjOOLFQEwrnKJ/4U5kMU0yWdiYIuU0zU1
         o6h3rxrsWpoxixiiYA7IR9vbW4ts6e+IfXCaqYCnFVuq1IrpHlFQnFrIdnYotW4amP
         tctJUUiSf8GnoN2fWLmDX1cEu4BFZa1g9fk3Zj++EsTrJAFt+5aEMpn9eTy02rpQW4
         d+nxECahVHgOyrydzdGuJx/y8m/jXnlpP6vmUY8i9dV7RtjIfnHtZrMvtK3c3GfATl
         e/2etEQTQntiQ==
Message-ID: <ddea6b99f6976174f352bbbad4a6c7aa6ac6b91b.camel@codeconstruct.com.au>
Subject: Re: [PATCH v0] mctp: defer the kfree of object mdev->addrs
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Lin Ma <linma@zju.edu.cn>, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 26 Apr 2022 11:30:08 +0800
In-Reply-To: <20220422114340.32346-1-linma@zju.edu.cn>
References: <20220422114340.32346-1-linma@zju.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.0-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lin,

> The function mctp_unregister() reclaims the device's relevant resource
> when a netcard detaches. However, a running routine may be unaware of
> this and cause the use-after-free of the mdev->addrs object.

[...]

> To this end, just like the commit e04480920d1e ("Bluetooth: defer
> cleanup of resources in hci_unregister_dev()")=C2=A0 this patch defers th=
e
> destructive kfree(mdev->addrs) in mctp_unregister to the mctp_dev_put,
> where the refcount of mdev is zero and the entire device is reclaimed.
> This prevents the use-after-free because the sendmsg thread holds the
> reference of mdev in the mctp_route object.

Looks good to me, thanks for checking this out.

We could also check out the semantics of ->addrs over a release (perhaps
we should clear addresses immediately with the write lock held?), but
that would be best done as a separate change.

So:

Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>

Cheers,


Jeremy
