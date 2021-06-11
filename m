Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218053A4A45
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhFKUmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:42:55 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:35620 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhFKUmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:42:55 -0400
Received: by mail-io1-f49.google.com with SMTP id d9so32535255ioo.2
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6SDaRZZDbkrrABCV8DGabRV0iA12L8boOdRU7uV2z4c=;
        b=qOOsRVspLZmHbUpL0O/8o8AI7Urfn8USWKKEUa6Zf/qJuamV0Tp1TQ7FUpJqhz0ozC
         awc3uMDjRPp12439LEd0DsbBOpeh+ao/i8qTbrGaxnAx4B2gx++jAc1XGROlEp/2iMVs
         wfe1iaabJKrkkDbz4g9CTuNrkRqkDk450FJZnLnXbR76TdFP6tNw1CHv6fl6QO9pC8OL
         e2TMy7cn1fQrvh2E27ShQVumIXllTnbnggq9ThqoL8DaiaCk+/bvS7xmzkTi0GANg+5p
         7IV3nnkw9EDDBAS/ulF/Nto6XiLiwq7HZmEZlQr1nUWyQVJXYuDDgDT8qB0PuuT9KBU2
         Mrbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6SDaRZZDbkrrABCV8DGabRV0iA12L8boOdRU7uV2z4c=;
        b=QAUOm3yYD19/ddzvsq7ciL4i7YQPXiGjOPAadG14qM6MCUKkJ8Wd0X6QjrCe7aIN2c
         hMXrtG1ozr+KEZTveXASJQNxyRY0pK4dhaqzAZ+sJ505zIRC/GQY+xzDgWAtZaE+Yzt7
         vAwJFEaxtdiV2AhNYAB61s6J6UWT7Bf5JJLqhk4yQidE35nxsK7zJ+2AlsK2MGE+Rukd
         5TmQ3MuuYmFOyEbqyVg4oG4XNrTpipUrssDfPaX6NreLsV1E2B33L1of722p2yaVKxBO
         b2RANzSAaG+wfzb3MftHrrTE0C0ZsDbxVQ1rVsbCWFSJIAGoFynUqN7a6XqH7Z6sQFfD
         msBg==
X-Gm-Message-State: AOAM533j101w+B/3yXzyhZRukfauAObYTUHzB09YOlxa0EVqV6fFtG+I
        xx/634wCRnDv4toetTBMJ97oRw==
X-Google-Smtp-Source: ABdhPJw+8d61r25fbfQ54LE61BANW7VncLgLeOL6cn0nfrLpi+/GcCfRh/4BY03t7xTQngxY9LDxPg==
X-Received: by 2002:a05:6638:12cd:: with SMTP id v13mr5537315jas.104.1623443983659;
        Fri, 11 Jun 2021 13:39:43 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id y9sm3761544ilp.58.2021.06.11.13.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:39:43 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     leon@kernel.org, bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        aleksander@aleksander.es, ejcaruso@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ipa: introduce ipa_syfs.c
Date:   Fri, 11 Jun 2021 15:39:37 -0500
Message-Id: <20210611203940.3171057-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series (its last patch, actually) creates a new source file,
"ipa_syfs.c", to contain functions and data that expose to user
space information known by the IPA driver via device attributes.

The directory containing these files on supported systems is:
    /sys/devices/platform/soc@0/1e40000.ipa

And within that direcftory, the following files and directories
are added:
    .
    |-- feature
    |   |-- rx_offload          Type of checksum offload supported
    |   `-- tx_offload
    |   . . .
    |-- modem
    |   |-- rx_endpoint_id      IPA endpoint IDs for the embedded modem
    |   `-- tx_endpoint_id
    |   . . .
    |-- version                 IPA hardware version (informational)
        . . .

The first patch just makes endpoint validation unconditional, as
suggested by Leon Romanovsky.  The second just ensures the version
defined in configuration data is valid, so the version attribute
doesn't have to handle unrecognized version numbers.

					-Alex

Alex Elder (3):
  net: ipa: make endpoint data validation unconditional
  net: ipa: introduce ipa_version_valid()
  net: ipa: introduce sysfs code

 .../testing/sysfs-devices-platform-soc-ipa    |  78 ++++++++++
 drivers/net/ipa/Makefile                      |   3 +-
 drivers/net/ipa/ipa_endpoint.c                |  12 --
 drivers/net/ipa/ipa_main.c                    |  36 ++++-
 drivers/net/ipa/ipa_sysfs.c                   | 136 ++++++++++++++++++
 drivers/net/ipa/ipa_sysfs.h                   |  15 ++
 drivers/net/ipa/ipa_version.h                 |   2 +
 7 files changed, 268 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-soc-ipa
 create mode 100644 drivers/net/ipa/ipa_sysfs.c
 create mode 100644 drivers/net/ipa/ipa_sysfs.h

-- 
2.27.0

