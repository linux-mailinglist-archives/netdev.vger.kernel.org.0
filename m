Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B9F37B319
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 02:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhELAlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 20:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbhELAlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 20:41:17 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC96C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 17:40:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id di13so25021968edb.2
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 17:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XPKq3ncQbo2NkSEsh6fh5MRYDgNK7edpruQbbS4fjew=;
        b=mLwQO5yy4SBxcQQOxmBsx1ntZaov+PUO1aFVV7OS6agccpJWzvVJTlug6VMVFTU315
         wuIv2YHa9wQqqAsQXrce/WTxihpgOVYv/xMIvvgSYSVZQUV6gDwTx7sTfU/o9tZy3ceL
         ZKY5rIlj4rIxtjNm8nHAgxMLVgCoPCdwbx8Klx4NFLuMR67A8E/W+D67vxzsnR5k7fxN
         KRWKgB2oEwaABPny3XrXacF+hy+o6L5bAA5m56KKVgAUcstyAh4uOqQA0+71PBucRnOY
         jzCOmlS8ROrNw0d+TstuJeQkpFO7G88RoqKSOmZXQAb2kAAWCaez1kzayFVmV4fGdN6l
         AOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XPKq3ncQbo2NkSEsh6fh5MRYDgNK7edpruQbbS4fjew=;
        b=tf6XMsr8zw+3rEnjF8JWxFcL/63rBOH3E9FBPUiv3jKxXKBlWJwfiZm6lU7xNLIM2f
         8dcaKvC1kXIZqRGP+pokGIBHuuxjtIxnbPGjsyCGpbfEuPRQO9DU3Wx26++jEFMtR0lD
         mach6r1sPKN8gRyW8giHENr4OSsIdlptIeG+2JrR5sZwbmiNyJEt+dOc25nuMH3AjSRd
         D0/W2FDDGT7dlffEefl4pYzfraZ9hdoaeUrogUj2EpJ3nXahrPAGTzAPQcWN3Jw2SESN
         e+LJlaREzJRtw7VTz1mLmuwG4PWkT7mN2sli1OB2Eg1tr7Ylz0h9D8KGyoWAVwsjeLHR
         UhRw==
X-Gm-Message-State: AOAM5304JNLJfZCyvhxPRl3s3vzNRFCp1NAVYJaKHmKMg8gTJYJxFf4y
        +nB3/NYWpBx0FSbxY8QsVXnAQC7zKTxLYUwkQTY=
X-Google-Smtp-Source: ABdhPJzPLrn/xNKtkZwys4PS1cwqMD4RikxdLAvLp9xBPeTjI5WE+Xeb3Fuznixnn1zDWOGrD28EQ6c40u0x4oqYZFg=
X-Received: by 2002:a50:8fe6:: with SMTP id y93mr39503633edy.224.1620780009039;
 Tue, 11 May 2021 17:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <1620774650-4464-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1620774650-4464-1-git-send-email-michael.chan@broadcom.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 11 May 2021 17:39:58 -0700
Message-ID: <CAKgT0UdN+wLGEe0By+2ZiyncXj+nhey-JcproHo5YyXSQBM8XQ@mail.gmail.com>
Subject: Re: [PATCH net v3] bnxt_en: Fix and improve .ndo_features_check().
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <gospo@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 4:10 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> Jakub Kicinski pointed out that we need to handle ipv6 extension headers
> and to explicitly check for supported tunnel types in
> .ndo_features_check().
>
> For ipv6 extension headers, the hardware supports up to 2 ext. headers
> and each must be <= 64 bytes.  For tunneled packets, the supported
> packets are UDP with supported VXLAN and Geneve ports, GRE, and IPIP.
>
> v3: More improvements based on Alexander Duyck's valuable feedback -
>     Remove the jump lable in bnxt_features_check() and restructure it
>     so that the TCP/UDP is check is consolidated in bnxt_exthdr_check().
>
> v2: Add missing step to check inner ipv6 header for UDP and GRE tunnels.
>     Check TCP/UDP next header after skipping ipv6 ext headers for
>     non-tunneled packets and for inner ipv6.
>     (Both feedback from Alexander Duyck)
>
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Fixes: 1698d600b361 ("bnxt_en: Implement .ndo_features_check().")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

This addresses the concerns I had.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
