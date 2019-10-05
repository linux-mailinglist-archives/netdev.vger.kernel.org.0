Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19CD3CCBDD
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfJESEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:04:46 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:50900 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbfJESEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:04:46 -0400
Received: by mail-wm1-f43.google.com with SMTP id 5so8710799wmg.0
        for <netdev@vger.kernel.org>; Sat, 05 Oct 2019 11:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=izhGcen8bKR8D4HH03JfhmcNndlrxsMpEk5M0Q11bC4=;
        b=e2gnxMmS3osoSBkuexw+CzEAipdBfs0o/UuIm3RSuOHXiXPwcgEALRsdwkKJsjKQGo
         qSfF1TDCLm0HxBZcIJaHFDzqf9stkySRYlH/stT85pe0vxHEEx3z6UUWC0IL3jBiwczM
         JStTdAFE7PkcFMemXmsUB0Am8JTymtdzc0OtqwgfmFL79qAKSfseXUv0971i1RYRx8CF
         KH5L9fz16ZRdeYTBLD3y4Sk4k5RzRFeE6CwBeokG1a609Gh2M0CHgJFbyVR0RPuCO0As
         TO7mMyQoXbCthAbTW69IkFjJl6zg34J37JZwhdlhvFZphcRI40S6xl2vHnyvjPkBgg5a
         s1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=izhGcen8bKR8D4HH03JfhmcNndlrxsMpEk5M0Q11bC4=;
        b=AA91Lwch7R/SjmDOsIkXFdbR0sIL+oJFyyata5Zp/MFMps6lSZOrOIWEZO/iGXlGbJ
         0xSjlCTuAttTbbcouL4l6b+zWnmpgG7hV8mUwEK9jnijxbS6GKepJ5GUPt4yAt9mcXzX
         mDN0Q5/wNTk/i4S7sNxMYuH0hKydn49n+W7bN40hArgqo+12ia2DgML1Mz9iEGjIcqhw
         vlBvummcD2u3zUjIFSDNQaRg3EshmaJpNc40M6SGwK4suu8vRIBziDsYIim9GY34xkHu
         Xmc8dxITXk6A4W7VUFDPIfY9WtLram7mnC9s5H6n8TAC6DTJxeMmclKCkopzG7Q7dU+O
         a0fA==
X-Gm-Message-State: APjAAAWuTvkQwx1IvaUgrPJlS5m/cISurbNzJE9apIUO40cTf3fRDm6W
        QJ8a1QxK6VwR0EAceot9zRhSFMZo5VI=
X-Google-Smtp-Source: APXvYqxV8sfJbKoT7UBYHnxedbyzicKAGqN7+lQI8Dj9aOASD267c4He0aqX8u54at5ZWW/Q0iHXuA==
X-Received: by 2002:a1c:4085:: with SMTP id n127mr15551075wma.68.1570298683640;
        Sat, 05 Oct 2019 11:04:43 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id y3sm23280579wmg.2.2019.10.05.11.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 11:04:43 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        alex.aring@gmail.com, stefan@datenfreihafen.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com,
        johannes.berg@intel.com, mkubecek@suse.cz, yuehaibing@huawei.com,
        mlxsw@mellanox.com
Subject: [patch net-next 00/10] net: genetlink: parse attrs for dumpit() callback
Date:   Sat,  5 Oct 2019 20:04:32 +0200
Message-Id: <20191005180442.11788-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In generic netlink, parsing attributes for doit() callback is already
implemented. They are available in info->attrs.

For dumpit() however, each user which is interested in attributes have to
parse it manually. Even though the attributes may be (depending on flag)
already validated (by parse function).

Make usage of attributes in dumpit() more convenient and prepare
info->attrs too.

Patchset also make the existing users of genl_family_attrbuf() converted
to use info->attrs and removes the helper.

Jiri Pirko (10):
  net: genetlink: push doit/dumpit code from genl_family_rcv_msg
  net: genetlink: introduce dump info struct to be available during
    dumpit op
  net: genetlink: push attrbuf allocation and parsing to a separate
    function
  net: genetlink: parse attrs and store in contect info struct during
    dumpit
  net: ieee802154: have genetlink code to parse the attrs during dumpit
  net: nfc: have genetlink code to parse the attrs during dumpit
  net: tipc: have genetlink code to parse the attrs during dumpit
  net: tipc: allocate attrs locally instead of using genl_family_attrbuf
    in compat_dumpit()
  net: genetlink: remove unused genl_family_attrbuf()
  devlink: have genetlink code to parse the attrs during dumpit

 include/net/genetlink.h   |  20 ++-
 net/core/devlink.c        |  38 +----
 net/ieee802154/nl802154.c |  39 ++---
 net/netlink/genetlink.c   | 295 +++++++++++++++++++++++---------------
 net/nfc/netlink.c         |  17 +--
 net/tipc/netlink.c        |  21 +--
 net/tipc/netlink.h        |   1 -
 net/tipc/netlink_compat.c |  19 ++-
 net/tipc/node.c           |   6 +-
 net/tipc/socket.c         |   6 +-
 net/tipc/udp_media.c      |   6 +-
 11 files changed, 243 insertions(+), 225 deletions(-)

-- 
2.21.0

