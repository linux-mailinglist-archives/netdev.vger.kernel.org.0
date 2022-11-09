Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA11D622EFB
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 16:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232031AbiKIPZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 10:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiKIPZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 10:25:25 -0500
Received: from smtpcmd0872.aruba.it (smtpcmd0872.aruba.it [62.149.156.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DDAA6263
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 07:25:20 -0800 (PST)
Received: from polimar.homenet.telecomitalia.it ([79.0.204.227])
        by Aruba Outgoing Smtp  with ESMTPSA
        id smw3oz6zpckLQsmw3o3w4p; Wed, 09 Nov 2022 16:24:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1668007458; bh=u8e+MUFKrsoYviBUUWyTGp0BzLYhxbLuJ+fOKhEJjPE=;
        h=From:To:Subject:Date:MIME-Version;
        b=Q+6tzOxHZEpDgKBHeOKoqFGDp5TnKZ6cRsZpfciiJuobBLEg9pvu27q7lPNSlf78t
         zfCEaOI9mYgGIOu20PJkzPuzwqDdkOhA05v0XXaAAIQ4fPpM/3Bc3BcCBrY+7eJUdt
         wfSS2MkGnYpi01CaJued4G0yBNeD/9FX7le/OnztrO6kFBaLszBgHNtgLc15LLaPDk
         xDITg/gA+rPVJBN8ir+JoPdeMa0Xc+jTsLIIO9WnMtI3oD2Qs9NiXATlXFiO/QR0mW
         EmaETdBHUo/2KIP1YrGT2GBh2+qo6cz854CBk3ID5KH9f6Gf+SofA4kV5UYQv2SVPf
         Eca4kq+/qn4fg==
From:   Rodolfo Giometti <giometti@enneenne.com>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Stephen Hemminger <shemminger@osdl.org>,
        Flavio Leitner <fbl@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Allow non "disabled" state for !netif_oper_up() links
Date:   Wed,  9 Nov 2022 16:24:09 +0100
Message-Id: <20221109152410.3572632-1-giometti@enneenne.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfFDAW6JvYF9/zt5CjygfYlEDES2VH1BmSelsBrMW3TGn9ot2B9nMZj9Q5IF2g1E//8zPOp4hjotFL3mgI/Ojwih1r7vvsaSZppwC2RJ4B1MiTSuEZjc7
 KAS8DcsfpUkNvaZ52f9h63yh4Gc35BZUQEI1cZRDUNCNwtm2mmQncO8Q9kZNUCDHvKjuJrZwDeX7Nbn1p1AKv0ABZq/KSw8Cp4zeyhjSUhwcYosn3FXYodxC
 KArL5gzdyzDkUfITA7VrgKxP/YDi0qTFyXPPAvx02lSU97CS4CQRnr/g2Tm4Alw+EPgRKTrmHEHjtxFi4cRf1daWGa+DumFjWh3wj0q8MdL8GMjzsBpL6atv
 PIT7aEjK
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch allows non "disabled" state even if the link is UP and runnign
but with no carrier.

I'm trying to implement a new MRP daemon in userspace and when a MRM detects
that one of its ring connections has no carrier, the normative states that
such link shall be set as BLOCKED (or LISTENING for Linux bridges). Current
code blocks this operation.

I think kernel code should implement mechanisms and not policies!

Rodolfo Giometti

---

 br_netlink.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)


