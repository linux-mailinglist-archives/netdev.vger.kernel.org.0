Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E72112B0A8
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfL0CiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:38:11 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35135 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfL0CiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:38:11 -0500
Received: by mail-wr1-f65.google.com with SMTP id g17so24965432wro.2
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aEc6uS3wyygPGEaHDugQErUUUyawUfDJ4DlGhrkJim0=;
        b=TuuaG1NdD7svux0CPmLiX9gUliJVjyIvIzi/Vbssv89wD0T8ojqeHXNsOSKPBNHbJ7
         0SQAf8dhwr5plPDXDHbT4k9dMYqYZR2D9oG0eHu3XXM/OIrTnUEQTAzTa0mIkz5HJWZT
         o86RGWgfNhNHpdr/oQR0SLZGYBKfQMeRSYDMxInR7IGSihifNMg3ik8d/OW8AR9lQCgz
         fMODDZ/DrtVpmJZ3e2iFvOFDIzQpJt8SQESp0/nliXc9DaaeLAMySfGZIaP/q7UOWFMX
         wKqE7jTJXAnv6oCAPZaACoe7Td7GFFta46SeonMlg9pm6bXevwVgGpvtbV+10NEQc9At
         ZoUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aEc6uS3wyygPGEaHDugQErUUUyawUfDJ4DlGhrkJim0=;
        b=Q6WU4ZMBuX8TO5IjE0LjxT+m+Ecl7pMYXwt4K9DA7e357GAcuunNuysUjfOM6nJ343
         JAe+kinhrOYvOCvgQhik1mjhMo5T1Lx3+wQ3Cquy9WBuUSzcYjlCU+XYDD+2zksqKfP4
         ylPxw9Ql4GG8qMtY/Dslb2N4eL6aT68xKWIK/APt6usPhY+TNncNOTlyLspgrG9t2h0z
         FMrfIZMkXPPHpYhIjkkOVafWNr0FlW3v4cMswP9AmOxrI65pPdYbGbZOUNh+LNxKdNXm
         tJ0Kbo2GVrdb5AWnE9LYZzQixJADMpYFwDTGoHk5jq6sM5LZYGLPDEmleViJWnItojBI
         JPNA==
X-Gm-Message-State: APjAAAWtg/LDCvmFedn2b7tbjFVMVNcflKBXoVKYrmZtFgvRlrzl6m0y
        TxRqlHngVE3A0T0llSBbBXLKxW17
X-Google-Smtp-Source: APXvYqw6VgWkgTG5ykyG6AFKY6VLYCLeMYmYMazyv8P0TdNZdrQDs1XdtE/YAy/4uFzQPP+b8vV1kA==
X-Received: by 2002:adf:ea0f:: with SMTP id q15mr46476823wrm.324.1577414288956;
        Thu, 26 Dec 2019 18:38:08 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id k7sm9718714wmi.19.2019.12.26.18.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:38:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     richardcochran@gmail.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 0/3] Improvements to SJA1105 DSA RX timestamping
Date:   Fri, 27 Dec 2019 04:37:47 +0200
Message-Id: <20191227023750.12559-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series makes the sja1105 DSA driver use a dedicated kernel thread
for RX timestamping, a process which is time-sensitive and otherwise a
bit fragile. This allows users to customize their system (probabil an
embedded PTP switch) fully and allocate the CPU bandwidth for the driver
to expedite the RX timestamps as quickly as possible.

While doing this conversion, add a function to the PTP core for
cancelling this kernel thread (function which I found rather strange to
be missing).

Vladimir Oltean (3):
  ptp: introduce ptp_cancel_worker_sync
  net: dsa: sja1105: Use PTP core's dedicated kernel thread for RX
    timestamping
  net: dsa: sja1105: Empty the RX timestamping queue on PTP settings
    change

 drivers/net/dsa/sja1105/sja1105_ptp.c | 36 +++++++++++++--------------
 drivers/net/dsa/sja1105/sja1105_ptp.h |  1 +
 drivers/ptp/ptp_clock.c               |  6 +++++
 include/linux/dsa/sja1105.h           |  2 --
 include/linux/ptp_clock_kernel.h      |  7 ++++++
 5 files changed, 32 insertions(+), 20 deletions(-)

-- 
2.17.1

