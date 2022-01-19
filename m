Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D110493DC7
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 16:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349282AbiASP45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 10:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242656AbiASP45 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 10:56:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB29C061574;
        Wed, 19 Jan 2022 07:56:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3DC9161522;
        Wed, 19 Jan 2022 15:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A69FC004E1;
        Wed, 19 Jan 2022 15:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642607815;
        bh=qYPvs1P2tAPB/MQXMIl5LXLnMgdArANdfiWB34ZUbd0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G1UjHTztuEdmWbxcGDKR+Kr5ut1HfWu4fyGvsi9t9g2duK0IUy1XG6y5jM0wp9ffX
         QHIr7K6IgC2hOh23hPe+wJxhRS9middvcOxpwofVZjimebRA4I3ljk7okBZNrdoF98
         chFOgs5Wscf4cXfFSZjKKrV+MJOjuHPpfhjt9qcUMEFjqHomJt2+BsN/HxlSueH9S7
         jdBEukTm+cgT9c5LRg4joc3zL3gfL7H/SHcSYaowcmXzfWd1htcF/aY7PELc61SQNq
         huknVVHsY6eWCupMkOZKvJZ1GALdlh4h4TwJ3iATjBZ5bW1Y5OOIdgsYxV8HiKhW9U
         k+K6WyYN7vMHA==
Received: by mail-wm1-f42.google.com with SMTP id 25-20020a05600c231900b003497473a9c4so15054724wmo.5;
        Wed, 19 Jan 2022 07:56:55 -0800 (PST)
X-Gm-Message-State: AOAM532JcdkFbAZrdmDnN+aqD5q/rVCb602tSvEt94ekc/FJHe4nsCYV
        36p2bnFKMEMszMbS/C/N9rpCy3ztEyZTzZibmlo=
X-Google-Smtp-Source: ABdhPJxRnhs7A5cmmQ4DRok0f/n1AD6ochZdHNyNG2DqQLYL+Ry/y865yHjSPngNazqhutNliwzmUkfnTXl+Wz9RQkI=
X-Received: by 2002:adf:dcc3:: with SMTP id x3mr3603165wrm.417.1642607814040;
 Wed, 19 Jan 2022 07:56:54 -0800 (PST)
MIME-Version: 1.0
References: <20220118102204.1258645-1-ardb@kernel.org> <20220119142532.115092-1-s.alexey@gmail.com>
In-Reply-To: <20220119142532.115092-1-s.alexey@gmail.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 19 Jan 2022 16:56:42 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFaM8dH=S3NZw9NqRtAfEa6vMwS0Q0g1v=v9myLyK6VyQ@mail.gmail.com>
Message-ID: <CAMj1kXFaM8dH=S3NZw9NqRtAfEa6vMwS0Q0g1v=v9myLyK6VyQ@mail.gmail.com>
Subject: Re: [PATCH net] net: cpsw: avoid alignment faults by taking
 NET_IP_ALIGN into account
To:     Alexey Smirnov <s.alexey@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Jan 2022 at 15:25, Alexey Smirnov <s.alexey@gmail.com> wrote:
>
> Doesn't CPSW_HEADROOM already include NET_IP_ALIGN and has actually more strict
> alignment (by sizeof(long)) than CPSW_HEADROOM_NA?

Yes, and that is exactly the problem. NET_IP_ALIGN is used to
deliberately *misalign* the start of the packet in memory, so that the
IP header appears aligned.
