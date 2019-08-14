Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EADD8C816
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729179AbfHNC3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:29:07 -0400
Received: from mail-qk1-f175.google.com ([209.85.222.175]:45162 "EHLO
        mail-qk1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728673AbfHNC3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 22:29:06 -0400
Received: by mail-qk1-f175.google.com with SMTP id m2so7577513qki.12
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 19:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=m5QQIHgaURy+lRyPupTLPy/4tvsA3s//zCshh/63PoY=;
        b=qHTw/LnBVKC9bXkyhI/TLHAaLs5XRMxYREUdsJzpDmR5QHScsN2gCrJkPNq3JmnxqI
         /zjcgbLDhnK04kMuL2wmrSyljYmO2rfx5hvpIXiblI9hDM+9nSVs3yvBPmWswL8IdgQQ
         yDdW+Ja+6nnPrFNnSRzxPy7vma4+a4bcZl2k8PR0aA/AiHM+/X2r1WdaAm2TsvbAHtZC
         2coTDYagc/sfHKuPUJoe9VI51Auca0afzL+CYl9QXyWrMsqvBSvYkk6yCrEKhbXbkMnZ
         HblkAgtK3Arm2Gn0kqvSJ9K7jHndt6UJWAeos4PORKDQ9drd4TIPoOiorHKt0SOTE4oa
         +3mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=m5QQIHgaURy+lRyPupTLPy/4tvsA3s//zCshh/63PoY=;
        b=NxQL6XbryhQFXPzX0lfsm+2Qjq1LsDhpqwvuXcwDgznAW1yPa9EmQnsMU3SQEcNfEw
         LR0rDbeAL6REar579BAVutKkmgkpHyQRmxSb27EYcq5yyEDEVfaaC1ayvrODZPjaW8++
         aunrsnLi817HmIXu3XlUCukFsfTC3gH8OuyexfuGfJs9VLGfuzkDkOJFkfXa3MLKIRks
         C5cDuowYdMjpeL+n9q/t3ADP+XXglMyDMdEeHEbjoc91dHLfT6ZhGVBJpwiHNbP+Lo6n
         6Wu8h4y+NP1g5G9SoBX/KyroTVr0Cb1c0SZIrRCAiRIruMw9i0V6FRMpuwtVsGByx6lc
         oMXA==
X-Gm-Message-State: APjAAAVUC0inq3SPM5gbJ8LdHxKD8E7vvfWe6DnX4MHDm4HJoNtnRfXs
        qZY8OdbYL7ozZqkRgO02e52H0A==
X-Google-Smtp-Source: APXvYqzLMMw6FHiol+IbtYP5HS1AaXUUQvXwdJakUJOkuTe0+CgcdXGxytSTk1lzmosjOZyFz52Lzg==
X-Received: by 2002:a37:648:: with SMTP id 69mr36692682qkg.248.1565749745852;
        Tue, 13 Aug 2019 19:29:05 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b1sm22867873qkk.8.2019.08.13.19.29.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Aug 2019 19:29:05 -0700 (PDT)
Date:   Tue, 13 Aug 2019 19:28:55 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>
Subject: Re: [PATCH net] s390/qeth: serialize cmd reply with concurrent
 timeout
Message-ID: <20190813192855.4d37cb89@cakuba.netronome.com>
In-Reply-To: <20190812144435.67451-1-jwi@linux.ibm.com>
References: <20190812144435.67451-1-jwi@linux.ibm.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Aug 2019 16:44:35 +0200, Julian Wiedmann wrote:
> Callbacks for a cmd reply run outside the protection of card->lock, to
> allow for additional cmds to be issued & enqueued in parallel.
> 
> When qeth_send_control_data() bails out for a cmd without having
> received a reply (eg. due to timeout), its callback may concurrently be
> processing a reply that just arrived. In this case, the callback
> potentially accesses a stale reply->reply_param area that eg. was
> on-stack and has already been released.
> 
> To avoid this race, add some locking so that qeth_send_control_data()
> can (1) wait for a concurrently running callback, and (2) zap any
> pending callback that still wants to run.
> 
> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>

Applied to net, thank you.

Please consider adding the Fixes tag for net submissions.
