Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20433DCAB3
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 10:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbhHAICn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 04:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbhHAICm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 04:02:42 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33164C0613D3
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 01:02:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id i10so16181876pla.3
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 01:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ls2d3RXduSKrKMZ7+H30ZeRrg5d7LOuxDYA+enFS5KU=;
        b=kWZymwXXz3i52S9/ue5lhG/bKXfzoJEtsT48z2lch04Sw3WPeloOL8YjDegITa3z1P
         4syE1ias5KPiDxpqpN8IsVegym8OBr97vwRk2xmKZB5hCGIFaxYVq019NboKMFA8xzsX
         W0vm76N/IejJoR4jvcx9HqVXq4zsb2gpj5axYxzp57kACEb4ZsMLGQ5PZo+sgnxS61FK
         PCGTKKycStUoktK1x959wDLVPenGXl1+G4KYhioSqEvAH/qgH6Le47LWm6YaJNBcdJpu
         /1uFAEkcz9KcsFoHfcVLYy0iwp40sN8bzlYr3e/nE+UnYO4YyF6GC5t8+iY1IKhPCuCE
         mr7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ls2d3RXduSKrKMZ7+H30ZeRrg5d7LOuxDYA+enFS5KU=;
        b=JA3gMJW1ALd3ZkjZT31lEY60mp2hAEik0i8UAfFfTPBamYzDnoj5eY5Pli5SifnSJJ
         Zz7hLfCi9m6LI14lY+tGVlwapqHeoSOAG05S6IJiH+LrtZ2HG3FqFfzNRgnPN5Pi0hF7
         2xbXbfU71CU2rMYwMTd46yl05T7ZwlcdL6wEqpPHMyx9P7GuqlYNCEwm5A2DmhHj2rFM
         Iay3/4Szk49yhlkTNuOp2+NkBx9POq1dPxkx1DhCWp5q+/zN/XNFSyks5mOpP45GOc5/
         sLny3+cd9m3jIu4juv2rcuDxXdveZz1GDhu5PtwXDqQNlY9x7Bgg+FRCrR+Itlz74lVR
         SjKg==
X-Gm-Message-State: AOAM532zvx7VCW73x/uN1z1gj2V7UU66TYhuK8vcTTv57CkT6ReVXbfs
        Eu3U738bkEbeQiFHCFmRM43mZzIb5KAGyrRF4XxaqZaOybo=
X-Google-Smtp-Source: ABdhPJzRx1BRRjBrPtwE60hK9sOrud/QTNj2w29RcebI2AcmqPdi3NFYWoRxdfdInHbXCuYoIdwZqLb8doNIUC0rwVg=
X-Received: by 2002:a17:902:bd49:b029:12c:7775:cdea with SMTP id
 b9-20020a170902bd49b029012c7775cdeamr9669093plx.68.1627804948714; Sun, 01 Aug
 2021 01:02:28 -0700 (PDT)
MIME-Version: 1.0
From:   nil Yi <teroincn@gmail.com>
Date:   Sun, 1 Aug 2021 16:02:18 +0800
Message-ID: <CANTwqXD1zfeyjXD+eyjzSaKBuT5k-4HQJ36AR4u3eUVzeO8b6Q@mail.gmail.com>
Subject: [BUG]drivers: net: usb: usbnet.c: dangling pointer in function usbnet_start_xmit
To:     oneukum@suse.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I found there leaves a dangling pointer urb in function
usbnet_start_xmit in v5.14-rc3,
1386:  entry->urb = urb;
1451:  usb_put_urb(urb);
1454:  goto deferred;

1492:   deferred:
1494:         return NETDEV_TX_OK;

left a pointer in entry->urb,  I'm not sure whether it cound be used
in usbnet_bh

Any feedback would be appreciated, thanks :)


Best wishes,
Nil Yi
