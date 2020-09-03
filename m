Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C6425BB87
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 09:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgICHWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 03:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgICHWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 03:22:40 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24121C061244
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 00:22:38 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id b12so1271851lfp.9
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 00:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=dd1Xbey5Rmz5chQroRcHkEPYyd9JujwxOIpiIWMB7Lk=;
        b=AFEDz2Vn7f5+9pSWhKX2icQNBGtNbRDuVfho2wm7rU4xNT7Zp8+T0a7c0CLhVxngPK
         QpVtd5gEhF7kZLeq72iYK9k+vcJHt3HbyS3pP5+9oZC5Q9xxpMkt+MegOrAeEl02lk+j
         NBZ+M3wcFEy+LfNzDntKIwk5sm+ic1L88LJzk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=dd1Xbey5Rmz5chQroRcHkEPYyd9JujwxOIpiIWMB7Lk=;
        b=JqUOBQ1rHLryyw+dh4E9HJ6mCw1eHoSH398EuqOsfgTRdvlcVAdnLDm/UYcpQ3BTWr
         Mhmnh0ADdTN1S96u7rZ+WLcA/JZ91FMlnCRf/4MF0up/QWGnKuV5pLnKwTxs/lQ8guz6
         AgxsrLPf7zq843p6UyX5IbQphW5psCLYxbuQGY+/39fLGZ2R1Bt2aJQx2B1D0uXLc+wc
         eVkPZTxxRUiIxty7H/ODKNyp2g3+peIde0JNcg4sxAgncvaPMUAsmKpPbrVT8vACHjxM
         mV6DYUAeteRAL3nUQoK75FHVmZoPlsiRGWQHoRVuH80wy2Hoz4KwUG26isKHO7JqFR+V
         F9lA==
X-Gm-Message-State: AOAM531wf2yZw5uI6q56ew0znu0rjk5ADGTtfAQ//+FuV+0PiAtpfqZj
        JgYDCYQ2n8UNfC+lwqN1oKCn/S3oZbEItVuVhtm2bQ==
X-Google-Smtp-Source: ABdhPJwGT6h0x+ESjQLM3vES6rwqtpPoww0bPjMRauogg/vIEq4tKj4m0yrd9tNcPDH/p+6EUQBrmcq0JOIEvWvnLyI=
X-Received: by 2002:a05:6512:34d3:: with SMTP id w19mr559197lfr.92.1599117756981;
 Thu, 03 Sep 2020 00:22:36 -0700 (PDT)
MIME-Version: 1.0
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Thu, 3 Sep 2020 12:52:25 +0530
Message-ID: <CAACQVJo_n+PsHd2wBVrAAQZm9On89TcEQ5TAn7ZpZ1SNWU0exg@mail.gmail.com>
Subject: Failing to attach bond(created with two interfaces from different
 NICs) to a bridge
To:     Jiri Pirko <jiri@mellanox.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, jtoppins@redhat.com,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jiri,

After the following set of upstream commits, the user fails to attach
a bond to the bridge, if the user creates the bond with two interfaces
from different bnxt_en NICs. Previously bnxt_en driver does not
advertise the switch_id for legacy mode as part of
ndo_get_port_parent_id cb but with the following patches, switch_id is
returned even in legacy mode which is causing the failure.

---------------
7e1146e8c10c00f859843817da8ecc5d902ea409 net: devlink: introduce
devlink_compat_switch_id_get() helper
6605a226781eb1224c2dcf974a39eea11862b864 bnxt: pass switch ID through
devlink_port_attrs_set()
56d9f4e8f70e6f47ad4da7640753cf95ae51a356 bnxt: remove
ndo_get_port_parent_id implementation for physical ports
----------------

As there is a plan to get rid of ndo_get_port_parent_id in future, I
think there is a need to fix devlink_compat_switch_id_get() to return
the switch_id only when device is in SWITCHDEV mode and this effects
all the NICs.

Please let me know your thoughts. Thank you.

Thanks,
Vasundhara
