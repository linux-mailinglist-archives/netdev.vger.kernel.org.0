Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04C2C4FEBF
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 03:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfFXByL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 23 Jun 2019 21:54:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52584 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfFXByK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jun 2019 21:54:10 -0400
Received: from mail-wr1-f70.google.com ([209.85.221.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hfDCM-0008Hm-Hd
        for netdev@vger.kernel.org; Mon, 24 Jun 2019 00:51:06 +0000
Received: by mail-wr1-f70.google.com with SMTP id s4so5592771wrn.1
        for <netdev@vger.kernel.org>; Sun, 23 Jun 2019 17:51:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8IZz66ecBNLIno5H2kZw/Xa/Z2hJiHNKU5YGuZD+4no=;
        b=LeLBkBLFIApqQ6vlJISFRRyYwYWjA9TTqxFF6l+W+64Pu3iWkkHbfMHPFTjeBsOBup
         DSVuhLddjE4uBJOqNn7Dl72GMv3qtskE7M7sRm3+fxol5bMN9L8UoZOtqhnB82xPI/vo
         ZLcI+pbheLjEHb/TJ/7zj2QwBA8+0Wh+dc/vJ9IvnieW9Gz824EFtkbYMuo6tc0S3hnw
         slg9HyiF1rXfegFmJo47rzagb4EQ1JUYewEwlkf7+SfOAKpzrX+ZTMZrjNOsepT1IuVw
         61QpI6iW6y3yK2+XQqENOtdnpbYtDQ+SP0Q/DVW+N7lFnEdUDbvTrqZqvf2DokWUX53h
         RIvA==
X-Gm-Message-State: APjAAAXJpVPpECrD1eNQB1+lnYoP3GXQnxkKYAg9AZP1ZyEIHc9ghn4M
        2PZu2wiWtFmD0UpyIQORP8HdraCudrHw+RMxjSoKKXACEUWcHEL6RAwkGZO/sUMuU/300WZcNeP
        YWtR/CyC8r7s5f0FdzT0y/Bv93iuC+Eoc8QZ+S+qYmIh9BnNBlQ==
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr12346336wmc.128.1561337466083;
        Sun, 23 Jun 2019 17:51:06 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw42BcGJjkf/3fRGKJ/pb5t0rlZVTW1mIFZ1Yiie3Hyxlh2NtrIHE+ZSJrInviQ4VGT/NKFD1A8qPazzeG4vTk=
X-Received: by 2002:a1c:7e90:: with SMTP id z138mr12346333wmc.128.1561337465914;
 Sun, 23 Jun 2019 17:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190621212634.25441-1-gpiccoli@canonical.com> <MN2PR18MB2528C51C0A23D9FA7744D883D3E10@MN2PR18MB2528.namprd18.prod.outlook.com>
In-Reply-To: <MN2PR18MB2528C51C0A23D9FA7744D883D3E10@MN2PR18MB2528.namprd18.prod.outlook.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Sun, 23 Jun 2019 21:50:28 -0300
Message-ID: <CAHD1Q_xJrVeZXHCpBprErkUXrxFMJ-SPSZ-w1deENcOjcT3tZA@mail.gmail.com>
Subject: Re: [EXT] [PATCH] bnx2x: Prevent ptp_task to be rescheduled indefinitely
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        "jay.vosburgh@canonical.com" <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 23, 2019 at 2:13 AM Sudarsana Reddy Kalluru
<skalluru@marvell.com> wrote:
>
> Thanks for uncovering this issue, and the fix.
> With the proposed fix, if HW latches the timestamp after 3 iterations then it would lead to erroneous PTP functionality. When driver receives the next PTP packet, driver sees that timestamp is available in the register and would assign this value (which corresponds to last/skipped ptp packet) to the PTP packet. In general, FW takes around 1ms to 100ms to perform the timestamp and may take more. Hence the promising solution for this issue would be to wait for timestamp for particular period of time. If Tx timestamp is not available for a pre-determined max period, then declare it as an error scenario and terminate the thread.
>
> Just for the reference, similar fix was added for Marvell qede driver recently. Patch details are,
> 9adebac37e7d: (qede: Handle infinite driver spinning for Tx timestamp.)
> https://www.spinics.net/lists/netdev/msg572838.html
>

Thanks a lot for the quick review and good suggestion Sudarsana!
I'll rework the fix based on your reference, and resubmit.

Cheers,


Guilherme
