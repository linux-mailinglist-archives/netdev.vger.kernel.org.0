Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1407F1080C9
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 22:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfKWV1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 16:27:17 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:41062 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWV1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 16:27:17 -0500
Received: by mail-pj1-f45.google.com with SMTP id gc1so4680549pjb.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 13:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pdR+fOWOXTaHGK56KazV3JC50sh8Nx5JD/1Vsro/I3g=;
        b=nPXvOTmB+ToT5tep2B45o6uHDZuqO09bZVj1j1M0iiawyQZz2L5qmc+8LC5Eim/9CP
         XcAnQZMkPy0Z76af+tlVrHg5hWrjWKm0OhUU/OrPu+aKidQy7goWkkZ/T4q/EZBwfDIZ
         drBAa0DK/YZq343S45/KVkwkkOIta0blCibdcoFgUowToRYP2pWJQLkJQCdtvwpfweV6
         M9aHFfOmbN7yTFXkuLdwOgABgh9U2C9IjLyu3vZwy6VrzXHOZLXUQVb57p1dNoQT2fYE
         iE6MzxWiLwHNgxM5mD3tW/unYv/icyW1T7w85n0oeNRIBcdhW1PgLPf37T3VTR/hx6CS
         p7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pdR+fOWOXTaHGK56KazV3JC50sh8Nx5JD/1Vsro/I3g=;
        b=W+Mg5o9oyQ2WL10P9lRiMg2rqeqfOeDFv8uQoVMzpvW2CycpnHRmzzzZtmZ2K04AYs
         WFLGSjLqRiQjKljMQCJb5jiopdbXLckfP1AWzTlJVpxYzauQGpu/ZeJo51lA9d5nQB9S
         eLWkrfl0UXkoVbV7n/Wy4Uok1kX16A66IV/X99Ln5ud6AoWwoT3kHTENEIL4Qd62qv3v
         uFJvUbaIyS9BMVxM2z04lgElHAaAL7fx5mGQUvL4+HkK0D9gRHcroCt+LLhWCYHiwoB1
         sKdNKZRc1b8+5aaOjfWRGLmG61twLaC9gSUL87VSJEozRvzfq6HAbxjZGYA3q/tNY/dE
         SW3A==
X-Gm-Message-State: APjAAAUXM3OYLnp+bGZhR5cVwOx8AvbNFeEjhXSHhLwqdQ7qccPlGKcm
        03dJ5jnNXKuqYr+d/JGjntdf2w==
X-Google-Smtp-Source: APXvYqwGG4ole6+3DlOJeO7VR3vTKapuCsbcjekkYaKxdF52tagORWOrUXg1GsyzHscM//z41qdCaA==
X-Received: by 2002:a17:90b:3d3:: with SMTP id go19mr27965056pjb.78.1574544435357;
        Sat, 23 Nov 2019 13:27:15 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id gx16sm2981169pjb.10.2019.11.23.13.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 13:27:14 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCHSET 0/2] io_uring: add support for connect()
Date:   Sat, 23 Nov 2019 14:27:07 -0700
Message-Id: <20191123212709.4598-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pretty trivially done, now that we support file table inheritance.
This is done in a similar fashion to the accept4() support, by adding
a __sys_connect_file() helper and using that from io_uring.

 fs/io_uring.c                 | 37 +++++++++++++++++++++++++++++++++++
 include/linux/socket.h        |  3 +++
 include/uapi/linux/io_uring.h |  1 +
 net/socket.c                  | 30 ++++++++++++++++++++--------
 4 files changed, 63 insertions(+), 8 deletions(-)

-- 
Jens Axboe


