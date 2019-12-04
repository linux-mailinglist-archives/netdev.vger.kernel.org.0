Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0360A1130D7
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 18:32:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbfLDRcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 12:32:25 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:45706 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDRcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 12:32:25 -0500
Received: by mail-pj1-f67.google.com with SMTP id r11so84090pjp.12
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 09:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=04f08x/BGZMIldWMMnPqD/nrVkZKi4PPGmsNh6XHSAE=;
        b=WO0oOd5AbU6X/g7lIRCtVXaIPPcG+ot3bOVEu8m/NvVpX5cW/bMOioo1qIiF9LlTPs
         4Q5lQ6XGjUMEMDHT8+wT4jeUrV63wXKkS2XsshWQQDSvzbQW4ALhAZvJV3XZ2nMeb7MD
         G4yDtYcivnHb6IMMbXzp2IJPfSn3z0KdVYDGbo9SDP/rxka9sYgbOxVyDnDJ/ZHd+26u
         S4ktpysLoee8kfsxPnZqUC0lwSnEzYFVKqrqyBnuOXKeI2ZQB8HFVF8NGnJKR4854gdr
         R0vVVx3p5qw3vWqaCY8aMqrkPtPrV+kGhxk6Bh9JCfA0WCMsCARsaUuHoY3O4GNyxJI5
         810g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=04f08x/BGZMIldWMMnPqD/nrVkZKi4PPGmsNh6XHSAE=;
        b=pIFM64Vm8Jd859Vevo30QSJ4Q7LN1obmAu0MeZQ5bsfeYLpLeBvJ6Mo3QmcGaIUwUL
         iQphsGwSmhs8IZK/H1ySDf/RTdtx/4mOrmJ1+mvTJDpA9GM8NpGDxAj2dRYxKmxJHPbc
         J25xwuVdYBhn9z2bfpUzYoLMIlTHwjXe7QfyYUJfuGeMuchwZDV4rvg/0Wqaag3nN3s9
         EuPh3aY+kujvwrOtQQyvb7343/eOaZuGDHRp3kbCn9sUd/+xfhPVbgU6DiFKHxZCdDEd
         Aw4SuKuf3adFDDa9r4BJzEcZ9G2RH+KDLw4naYrCnTRpdjUw50kLiuHffZx94uiW3e1i
         1q7A==
X-Gm-Message-State: APjAAAVO8yILF6r1D4R91egAOQBjmWkWWPQ92UdtHtlpP3IPxxOMZ1/A
        Kg0FoMsGUYmhUyJYNpO9Rjs=
X-Google-Smtp-Source: APXvYqzwjuwLw/GWhKddHRGQBYzQPvoEnlRtjR2Blf36ibi7GUWzkHglveqK1t1Zc0MQUk8WUEAr5w==
X-Received: by 2002:a17:902:a615:: with SMTP id u21mr4705879plq.44.1575480744398;
        Wed, 04 Dec 2019 09:32:24 -0800 (PST)
Received: from [172.20.160.202] ([2620:10d:c090:180::5fe1])
        by smtp.gmail.com with ESMTPSA id i9sm5080149pfd.166.2019.12.04.09.32.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 09:32:23 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Vladyslav Tarasiuk" <vladyslavt@mellanox.com>
Cc:     "Tariq Toukan" <tariqt@mellanox.com>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Moshe Shemesh" <moshe@mellanox.com>, netdev@vger.kernel.org,
        brouer@redhat.com, ilias.apalodimas@linaro.org, davem@davemloft.net
Subject: Re: page_pool: mutex lock inside atomic context
Date:   Wed, 04 Dec 2019 09:32:22 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <EF240E77-367A-44C2-A870-48DEE488B248@gmail.com>
In-Reply-To: <DBBPR05MB6522EAE7219849CE10EF5023BF5D0@DBBPR05MB6522.eurprd05.prod.outlook.com>
References: <DBBPR05MB6522EAE7219849CE10EF5023BF5D0@DBBPR05MB6522.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4 Dec 2019, at 9:05, Vladyslav Tarasiuk wrote:

> Hello Jonathan,
>
> Recently we found a bug regarding invalid mutex lock inside atomic context.
> The bug occurs when destroying a page pool that was registered as a
> XDP allocator.

Thanks for the bug report - I sent a patch to -netlist yesterday which
resolves the problem.
-- 
Jonathan
