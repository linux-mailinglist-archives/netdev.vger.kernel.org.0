Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF11C13B10
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 18:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfEDQGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 12:06:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33784 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfEDQGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 12:06:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so4471860pfk.0;
        Sat, 04 May 2019 09:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyrLUtvrUj7rK2+u/bTU+h/6d2PJHm89dFJXzTbVkYk=;
        b=HXbsCaWhjnQYe1gR/0W9pmCfasI0sH7vWnDhTOJoA18NZgikCRjmR6zzUlJ5kI3bUu
         BY8mRZdjYs6jT4iyceTZrCRkHXUcYomP+KapM0Vjt7+Om8uMDxExVcJVMIQjW+l0NFN0
         3s/hfiuCXYSL8qrXamP3py8dOkrteyOjCbrWrxLxFVDAYcKOJkXUv2YLryWRK6yKr2Ib
         I98aS2DmKSo5qm29NibMLKyJQAy4UOyDALHb8dmJclZLDolC2+PUPsn9dhJ4Py/EuypC
         CU2KILk3Vuq5eCG5mKnkrdFij1rGDqQq5/8+DytxBAU4tKxPrOi6n820BzfTgGbu7Dw2
         omGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qyrLUtvrUj7rK2+u/bTU+h/6d2PJHm89dFJXzTbVkYk=;
        b=Q9bXEJEWFn1mlnk318MIgPaupcoYa3GNjRa0zPM8VrKDnvjyzJ/M0FgNj543dHJaHi
         8gK+Fp0Wudvqxx1UwuBt1cAG/SMYSG6yoURfHXfPQ2FsG1+Q1/8XKSvnwhN68mSfdV+m
         ixXk4jYsM6u1jsWOLvhhzx+d7XdV5LGbRJbF4QmTOo36WRFQDZepFxjV3SGQOKXhjDEj
         KNxzaGM2TW2CWVXG71Fas//u+ile6CD3j3nBWVe+jOzT5zo55pFT2Yk3mlWhGf+9LuCD
         zJVZ3vHA4DLoHqznkO+zB1snm3iePMlN/cL0fdSpf//Rqt0GFoIrBdrk26NhJb+9spLC
         VmmA==
X-Gm-Message-State: APjAAAX38Hov8vF7/6x/mBCIhG+NEv8lB541bhJZ2lCD1XdsYXMKNPeb
        FqyR+taC2vq6//k60ffnJ0Y=
X-Google-Smtp-Source: APXvYqzk+EZDkBEEBnfal9mIdEr++EJ5tMS+Z1BREju9i9KG/rn+96P0RI4MdWC73pNqiYvFH0TPAg==
X-Received: by 2002:a63:5166:: with SMTP id r38mr19850328pgl.429.1556986003428;
        Sat, 04 May 2019 09:06:43 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id n67sm8032593pfn.22.2019.05.04.09.06.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 09:06:42 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bruce.richarson@intel.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/2] Two XSKMAP improvements
Date:   Sat,  4 May 2019 18:06:01 +0200
Message-Id: <20190504160603.10173-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series add two improvements for the XSKMAP, used by AF_XDP
sockets.

1. Automatic cleanup when an AF_XDP socket goes out of scope. Instead
   of manually cleaning out the "released" state socket from the map,
   this is done automatically.

2. The XSKMAP did not honor the BPF_EXIST/BPF_NOEXIST flag on insert.


Thanks,
Björn


Björn Töpel (2):
  xsk: remove AF_XDP socket from map when the socket is released
  xsk: honor BPF_EXIST and BPF_NOEXIST flags in XSKMAP

 include/net/xdp_sock.h |   3 +
 kernel/bpf/xskmap.c    | 121 +++++++++++++++++++++++++++++++++++------
 net/xdp/xsk.c          |  25 +++++++++
 3 files changed, 133 insertions(+), 16 deletions(-)

-- 
2.20.1

