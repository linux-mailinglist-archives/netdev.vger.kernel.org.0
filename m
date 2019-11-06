Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E12BBF0E6F
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfKFFja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:39:30 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:46092 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfKFFj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:39:29 -0500
Received: by mail-lf1-f54.google.com with SMTP id 19so11844327lft.13
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 21:39:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GHIf5mDgZLljmFUkOq24Gp9TCbOM9O3cWPqt9cOVGZ8=;
        b=Lpn0EaXP7QQ2PPid317+Zmtpz4I05Prd/oE0N7JbiAUP02AFeP7k0qv11Kb/1/zF9X
         tM9vBjnczPDzcydBssC0xmyStZ1Ru0ZPkFVDdYwQEFjBWpjsmF1N57OGiRbYQhASQeXJ
         Zkp2HV99KLf59yquoHDT4Z9zSoIRvCi+OYAOisLwNV94PKYgkVpqcHxhUY0FCiaybkD8
         6MKTzl7w00KErFvhGVKXU3bNq9cSyQkQ4ElAj1Y58mAfpdN1sQbe8kL4s64j10zB7f1x
         UtnDg2qzKgx1bMtX0UY/DvoRUt5rUeg7mKyEzRfPIrFTp23Evt6YIQOe0oNBfGcNIX6R
         HE6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GHIf5mDgZLljmFUkOq24Gp9TCbOM9O3cWPqt9cOVGZ8=;
        b=nMGIdTC5oCYgkiTF0YSkrKPk90G7R3Afy5f/fwIYbpzBii2nXBJY0WutARtNL3kbFF
         cdzKYQvJQPp1T8TozuN9m+x+40VlRBEMXkb96WuMs2RR6XIi/TABENf5TLIt5KVKO5M7
         l25d+EkeDIgtBZ6wlgTZju9ER/NfyO2u6dKvlPLHMg/O6tpDHkXrWsC7ElLpJKhssGRs
         EJscWh2wxkADopGslh9BGu0KIWnYTu3yIlEamUL5aJe0FDu59osl6JeS3a85HrNtRwzx
         gzHnsce5TRHf9aFZAG2Tjte0LSBqXVBTtqkOA8pRqS+rVeNmI/OfbaDz6XERfv/T/bUd
         QCew==
X-Gm-Message-State: APjAAAXP8OIVzVGbySzkGC3hGeQk8GY3cayWDzFjAr8unTlu/IYMkILM
        CbC7fXKUmnOLcrMXwzOpckoRbw7Y53o=
X-Google-Smtp-Source: APXvYqw9LhBoyZ+T7F0ttWVowqdJU54xLZJ1xtS3yNseyOPCBT0Vl/GT/5OZF2Jqps3IA8wel5FbyA==
X-Received: by 2002:ac2:44a9:: with SMTP id c9mr6517246lfm.26.1573018767595;
        Tue, 05 Nov 2019 21:39:27 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c22sm754737ljk.43.2019.11.05.21.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 21:39:26 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v2 0/5] Add namespace awareness to Netlink methods
Date:   Wed,  6 Nov 2019 06:39:18 +0100
Message-Id: <20191106053923.10414-1-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changed in v2:
- address comment from Nicolas
- add accumulated ACK's

Currently, Netlink has partial support for acting outside of the current
namespace.  It appears that the intention was to extend this to all the
methods eventually, but it hasn't been done to date.

With this series RTM_SETLINK, RTM_NEWLINK, RTM_NEWADDR, and RTM_NEWNSID
are extended to respect the selection of the namespace to work in.

/Jonas

Jonas Bonn (5):
  rtnetlink: allow RTM_SETLINK to reference other namespaces
  rtnetlink: skip namespace change if already effect
  rtnetlink: allow RTM_NEWLINK to act upon interfaces in arbitrary
    namespaces
  net: ipv4: allow setting address on interface outside current
    namespace
  net: namespace: allow setting NSIDs outside current namespace

 net/core/net_namespace.c | 19 ++++++++++
 net/core/rtnetlink.c     | 79 ++++++++++++++++++++++++++++++++++------
 net/ipv4/devinet.c       | 58 +++++++++++++++++++++--------
 3 files changed, 129 insertions(+), 27 deletions(-)

-- 
2.20.1

