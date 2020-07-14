Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADF421F715
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgGNQSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:18:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNQST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 12:18:19 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0A5C061755;
        Tue, 14 Jul 2020 09:18:19 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id k15so12147499lfc.4;
        Tue, 14 Jul 2020 09:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=vHKM0AHFlg7BGQiMriXkHvJOUHkWNn6XrS5eJsFzS0E=;
        b=PxEWzwLp1YA/YskCyZFuVCTENSh98jt39ONfJ329yyHyeP2qlussesbvcH0OI/1AEc
         dwJEBDzkirJDL0fa5R+/ICkP7hTCZHCb65Uo9pWuHX3LlSEohisKRt7cQih7D1NQq4V9
         wuO8vvXY7fNECpOQCyOxX5AcrOMmiPHxiObTskPMQlZu49lrCOBk/S149jKUEOfbzsXC
         2rDOinZ2mwaRKWFMKB1DajT6BB3vE4HvZIIJcExZjFxOZ3fstIvN7YA0Sb7fk5lye1KV
         mxM9cJW4FdLFbCscCU8FX4uMJ6LKJmnRlC8+uM235LLbDjJapyjZODt/xPNvlR6l87Wx
         PvWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=vHKM0AHFlg7BGQiMriXkHvJOUHkWNn6XrS5eJsFzS0E=;
        b=dTOngar4Bs5CRKV104n1nIkSCWpEBsdAdxJh1Wf5VT89nwbkQ9im27cLovh+TWZfHw
         dB2HU1XXTIfrmm8F4bJ7I0Qa8PMAhEPXs+5sUxxnbQyNKPycXmMhh1zraR/KrLjMPHAk
         A9Pd+YBAZwloA4FZav1NcZAjXKNT+U+tbexzW8N3fVdCFgLfCURatB+XlhqUl599hVKz
         JYqWaaAez8pQRGSkKeJlR9FzSbKDcXvoHFXSXv8DS6Kq5x5RsSS4oE7sYEptUlip/FWX
         x7Pz0cdBkkvjFR9ADPLhlCrbYwCvg+aSkitXMPxtgQMtnFNqvRbO3P6rSo8fDYZjt01H
         iSwA==
X-Gm-Message-State: AOAM5315tLsHfnLuse2dihSrKDhY2xUjr7X9P+RcE0EilYz2z8P8TWHk
        ibcTWA0+h2N8eLHxrqAVCow=
X-Google-Smtp-Source: ABdhPJwbKaHklvYuQ4KMMROMkkWaTt7qO6CT724B94BC3Byyb7bwzTxtqsuy7FUYcFyV2eV2ZVNxkA==
X-Received: by 2002:a19:b07:: with SMTP id 7mr2587565lfl.38.1594743497736;
        Tue, 14 Jul 2020 09:18:17 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id u26sm7321492lfq.72.2020.07.14.09.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 09:18:16 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
References: <20200711120842.2631-1-sorganov@gmail.com>
        <20200711231937.wu2zrm5spn7a6u2o@skbuf> <87wo387r8n.fsf@osv.gnss.ru>
        <20200712150151.55jttxaf4emgqcpc@skbuf> <87r1tg7ib9.fsf@osv.gnss.ru>
        <20200712193344.bgd5vpftaikwcptq@skbuf> <87365wgyae.fsf@osv.gnss.ru>
        <20200712231546.4k6qyaiq2cgok3ep@skbuf> <878sfmcluf.fsf@osv.gnss.ru>
        <20200714142324.oq7od3ylwd63ohyj@skbuf>
        <20200714144409.ymnj6fhlnztsg6ir@skbuf>
Date:   Tue, 14 Jul 2020 19:18:15 +0300
In-Reply-To: <20200714144409.ymnj6fhlnztsg6ir@skbuf> (Vladimir Oltean's
        message of "Tue, 14 Jul 2020 17:44:09 +0300")
Message-ID: <87d04ydq9k.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:


[...]

>> Acked-by: Vladimir Oltean <olteanv@gmail.com>
>> 
>> Thanks,
>> -Vladimir
>
> Of course, it would be good if you sent a new version with the sha1sum
> of the Fixes: tag having the right length, otherwise people will
> complain.

Ah, thanks for reminding! I entirely forgot about it due to this lengthy
discussion. Will do!

Thanks,
-- Sergey
