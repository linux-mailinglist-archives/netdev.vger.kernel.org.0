Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB08D4A57B6
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:27:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbiBAH1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiBAH1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 02:27:42 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2FFC061714;
        Mon, 31 Jan 2022 23:27:41 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id s16so14437070pgs.13;
        Mon, 31 Jan 2022 23:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=gb6FpjDviXqkxJ6tLKBKooggf+e2HvpPzlaYq1JqIm4=;
        b=bnc/76N1EHpYnVPW0XvmUduROAoPN/BPMdfuK+CbCaGMaDLhq9vVyYnoauw4VUy74M
         goJr9Vz1HZ/knFlNZl3LdsRqn5exiyvIQX7oF1Klbm8vRves0iepp3npexp9I0RM91z6
         B+LVOWEg0833b+k8LBpD4jzy5z172K9hHkAqbLSsiEPsJYn3p0mCW2DI7wau+ryZ7GAv
         /petSKnTeBErJ1rtmG2aMKvd4oGx5YWsRRQMFqZXPK9PMXvU7nq2iXYnCREQ71USITOc
         9b2uZN2O8lkx+N1A0KzvnJUIuU8do4nHw6v+WxEBj2+IGY8z32n9ioLMVuuRVxWTmSIZ
         c9vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=gb6FpjDviXqkxJ6tLKBKooggf+e2HvpPzlaYq1JqIm4=;
        b=FlV30beL7BmElpn7vHv1FPVFMrECdswllyJi+YVjTSHOxXXbvENHa+OqE63bSGQc9S
         he8iVIwjD78qr2c0jEyvYiGJrpgHfZtk6CHpuSK9No4T2lEUh/aCJxvC1tgEm+hpSvFB
         99lfN3vTVk1xKk1GKqTQAOPbfdmSBE6T2ns6IfglHRZTHEvLbJVdMwyx1irIk3kvFnBk
         QU1auH5UX4syHPpryGs/70hMcVEAXdaMoLPqser/Gt5BxoPmom+o9SCTky3e4JN7Dk2S
         UNr6E+efLavckOEtrkjvi3ehiq4UCfR/KanPsWANm6SFUPNlcjO7YlwlN2W0OImIfICG
         VUrQ==
X-Gm-Message-State: AOAM5302QhI8LFasHiAyZgfvtZWCtqJF6izTR7aXwsa8FVP5s11RQ/fV
        GAmmgnAoFw++Ro0ro0C7BFxFrdqKjYs=
X-Google-Smtp-Source: ABdhPJwE6FampCug81yvTDRInbet6MFgiUScRXkZxzKvq4ickx/7NOJpJQ0E7JVRTT0yev9CkhIFKw==
X-Received: by 2002:a63:1a21:: with SMTP id a33mr19938856pga.35.1643700460589;
        Mon, 31 Jan 2022 23:27:40 -0800 (PST)
Received: from [10.59.0.6] ([85.203.23.80])
        by smtp.gmail.com with ESMTPSA id c14sm19908190pfm.169.2022.01.31.23.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 23:27:39 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [BUG] vhost: two possible deadlocks involving locking and waiting
To:     jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <22f57c53-1a0b-ced9-b36e-1b4de8d55572@gmail.com>
Date:   Tue, 1 Feb 2022 15:27:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

My static analysis tool reports two possible deadlocks in the vhost 
driver in Linux 5.16:

#BUG 1
vhost_net_set_backend()
   mutex_lock(&n->dev.mutex); --> Line 1511(Lock A)
   vhost_net_ubuf_put_wait_and_free()
     vhost_net_ubuf_put_and_wait()
     wait_event(ubufs->wait ...); --> Line 260 (Wait X)

vhost_net_ioctl()
   mutex_lock(&n->dev.mutex); --> Line 1734 (Lock A)
   vhost_net_flush()
     vhost_net_ubuf_put_and_wait()
       vhost_net_ubuf_put()
         wake_up(&ubufs->wait); --> Line 253 (Wake X)

When vhost_net_set_backend() is executed, "Wait X" is performed by 
holding "Lock A". If vhost_net_ioctl() is executed at this time, "Wake 
X" cannot be performed to wake up "Wait X" in vhost_net_set_backend(), 
because "Lock A" has been already hold by vhost_net_set_backend(), 
causing a possible deadlock.

#BUG2
vhost_net_set_backend()
   mutex_lock(&vq->mutex); --> Line 1522(Lock A)
   vhost_net_ubuf_put_wait_and_free()
     vhost_net_ubuf_put_and_wait()
     wait_event(ubufs->wait ...); --> Line 260 (Wait X)

handle_tx()
   mutex_lock_nested(&vq->mutex, ...); --> Line 966 (Lock A)
   handle_tx_zerocopy()
     vhost_net_ubuf_put()
       wake_up(&ubufs->wait); --> Line 253 (Wake X)

When vhost_net_set_backend() is executed, "Wait X" is performed by 
holding "Lock A". If handle_tx() is executed at this time, "Wake X" 
cannot be performed to wake up "Wait X" in vhost_net_set_backend(), 
because "Lock A" has been already hold by vhost_net_set_backend(), 
causing a possible deadlock.

I am not quite sure whether these possible problems are real and how to 
fix them if they are real.
Any feedback would be appreciated, thanks :)


Best wishes,
Jia-Ju Bai

