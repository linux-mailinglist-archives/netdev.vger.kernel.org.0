Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCDE2330658
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbhCHD0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhCHD0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:26:00 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758B6C06174A;
        Sun,  7 Mar 2021 19:26:00 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id d9so4011924qvo.3;
        Sun, 07 Mar 2021 19:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GIzXTjeuPHO40MXssf5KZd6/6C9TGxusOUAlnIGcvHE=;
        b=AgRLgjqZHKsyKjb+AftRNWp4BPKN/k+aiuMr91Am8OVnUcUy2HD/e750Ir2bdKcAbH
         q78V3oraIIcGmEAhdLT9if+bcb0vDcTSDvMRkHJNuG0rxsCZiEezrRUzRGESq4b37yXy
         mGw3kzRr1LL2yteNSwmO2Z2XflfF3ElGFhZv2c6yw1W8g6GQNTLyHVehUV+q6bxfdBaV
         QmKMh8uNYv97h27a9p2lOQdCojRPcHaW5t8Fllqubm5Zs9XO/qkhmKxjtQFTMhBlWcYU
         IHfe+MYUBXQN3myd6WDZ2Xl09r7RIDGaMKSyKQw3RF4NUty5PUF82ktvVUy2jUvv0N9P
         XsBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GIzXTjeuPHO40MXssf5KZd6/6C9TGxusOUAlnIGcvHE=;
        b=XVBwqRb5g5sN0wYc/wuJLIQU9hI0XrDn8+9EPPmH4oV6AsGCbhISDPyDQVCy0tTA+E
         sQoM22b8TKmvoqBOOhVYmcX6UquT4g1leDz032HfRPTH1OxsuZtiuaULK7DJ+cghr7NK
         pV89DuVX/cFkP3K0ca5ym0LLVBpxsOEskb2cqNLqSg2zGsK2whwAUMD6sJQ74YrmpGbg
         C2YIxtgMGuKch81MS+sUKSmb6X0HjtIZiBm3tFDvH1N/rNXDNDoiI/TFsSsygZTPAXA1
         JHivmSXYsDVoQzrR+6XFXdNgudg+lLXdE93gB4jGVlkew3XOCotDVmUlp31lLEkXS4w/
         TBhQ==
X-Gm-Message-State: AOAM532hkNiWMy9ckwQNI33fZlDK7EotUSaFg/ltfHD6J4hS3qYh7n1D
        rhEqS8K1bEeb3LviXz7RRcA=
X-Google-Smtp-Source: ABdhPJx/vH+DfLRUFC5u8+OnSy9VUf9GVdXWVAz/zDBls6i16eINMBDenl1PZcD97tFbOGuUFrV5WQ==
X-Received: by 2002:a0c:f890:: with SMTP id u16mr19466777qvn.21.1615173959433;
        Sun, 07 Mar 2021 19:25:59 -0800 (PST)
Received: from tong-desktop.local ([2601:5c0:c200:27c6:99a3:37aa:84df:4276])
        by smtp.googlemail.com with ESMTPSA id r7sm339725qtm.88.2021.03.07.19.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 19:25:59 -0800 (PST)
From:   Tong Zhang <ztong0001@gmail.com>
To:     Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ztong0001@gmail.com
Subject: [PATCH 0/3] fix a couple of atm->phy_data related issues
Date:   Sun,  7 Mar 2021 22:25:27 -0500
Message-Id: <20210308032529.435224-1-ztong0001@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there are two drivers(zatm and idt77252) using PRIV() (i.e. atm->phy_data)
to store private data, but the driver happens to populate wrong
pointers: atm->dev_data. which actually cause null-ptr-dereference in 
following PRIV(dev). This patch series attemps to fix those two issues
along with a typo in atm struct.

Tong Zhang (3):
  atm: fix a typo in the struct description
  atm: uPD98402: fix incorrect allocation
  atm: idt77252: fix null-ptr-dereference

 drivers/atm/idt77105.c | 4 ++--
 drivers/atm/uPD98402.c | 2 +-
 include/linux/atmdev.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1

