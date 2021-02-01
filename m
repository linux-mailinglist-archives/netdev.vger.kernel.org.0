Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E8D30ADD8
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhBAR3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbhBAR3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:29:34 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E087C06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:28:54 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id h11so18199158ioh.11
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:28:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uLCedEHFwqPaDME/K4+4FPLqimlKNLFuYM52ltTab0E=;
        b=ePEJY2qcloWxjPIxj/5TkvquPA5H1F/P4lrlFUqGBcW/SCjJZPR9Yt36rFocVv8jxd
         Sdn+w8WnnNuI8UG3Nby5sNs0aF30ia927hJ6IobE8tmtfKYtW2qkHApjXkRkm1jMGnYV
         fFhdzUJ0V/lvtIB1L33Xfg0MSAmWtP8JB1/k76Rldinglk5UhPYCG4R/f/fHGarV97pg
         AtEwFAHMCvFCm1Ea3ysDMseqbjmKDBI0liLYc4KHTckXm75zGWN00xSSFDHvqCkUwOMU
         FIWqXGEI4n5xVCib4JU2IUhRA8UAtLiUJm7hVo9RP1MxrxMi7jJyfBciJIsfIA2CbHd9
         0bqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uLCedEHFwqPaDME/K4+4FPLqimlKNLFuYM52ltTab0E=;
        b=CpFBfHVbKcZaK5AQWPnrME1w8ANvSGnqO7fYQ1IkzassJH+coPQlSmN9v0xJp28tC+
         kuDkPXKQDbCaLxkA2LzhL9fsdhgF1WxMlhtQWSiCBaUWAn3/rzn83JcMFtPTj6nRrv1U
         10jLc7y56hKhcfUIyzrB81sXXN9EwwQor0LQPbewFZs3DOpm49qTGaVXthR3PBHR/FJ3
         XJa08qm9nI5Ymr42oA+jjvLsuNyggWT/KlF80h34iuFs/lmfc6wkOxhN4DMD07Gfdpjd
         bTR4q/TEWn6aCpbEpXa794JoYzZQu++4MDbiMYMVSLI4eQRggTVxTAAuncu+UblC/Ozf
         +1vw==
X-Gm-Message-State: AOAM532PT/zKgU5x+p0VCEw+aT5c5FdWA5U69zhzLx1BKAvDBb3bcva+
        4XWwJDg8kw1KqrxvMNfG2912mw==
X-Google-Smtp-Source: ABdhPJxO6DUhpKl0y3lH7fd314GFIjQ9lJ53uGcMeFjMw3rsgOZ1Iwlml91tAzfL/+/aH6YM9UULtA==
X-Received: by 2002:a5d:9713:: with SMTP id h19mr13212099iol.14.1612200534065;
        Mon, 01 Feb 2021 09:28:54 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v2sm9529856ilj.19.2021.02.01.09.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:28:53 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/7] net: ipa: don't disable NAPI in suspend
Date:   Mon,  1 Feb 2021 11:28:43 -0600
Message-Id: <20210201172850.2221624-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is version 2 of a series that reworks the order in which things
happen during channel stop and suspend (and start and resume), in
order to address a hang that has been observed during suspend.
The introductory message on the first version of the series gave
some history which is omitted here.

The end result of this series is that we only enable NAPI and the
I/O completion interrupt on a channel when we start the channel for
the first time.  And we only disable them when stopping the channel
"for good."  In other words, NAPI and the completion interrupt
remain enabled while a channel is stopped for suspend.

One comment on version 1 of the series suggested *not* returning
early on success in a function, instead having both success and
error paths return from the same point at the end of the function
block.  This has been addressed in this version.

In addition, this version consolidates things a little bit, but the
net result of the series is exactly the same as version 1 (with the
exception of the return fix mentioned above).

First, patch 6 in the first version was a small step to make patch 7
easier to understand.  The two have been combined now.

Second, previous version moved (and for suspend/resume, eliminated)
I/O completion interrupt and NAPI disable/enable control in separate
steps (patches).  Now both are moved around together in patch 5 and
6, which eliminates the need for the final (NAPI-only) patch.

I won't repeat the patch summaries provided in v1:
  https://lore.kernel.org/netdev/20210129202019.2099259-1-elder@linaro.org/

Many thanks to Willem de Bruijn for his thoughtful input.

					-Alex

Alex Elder (7):
  net: ipa: don't thaw channel if error starting
  net: ipa: introduce gsi_channel_stop_retry()
  net: ipa: introduce __gsi_channel_start()
  net: ipa: kill gsi_channel_freeze() and gsi_channel_thaw()
  net: ipa: disable interrupt and NAPI after channel stop
  net: ipa: don't disable interrupt on suspend
  net: ipa: expand last transaction check

 drivers/net/ipa/gsi.c | 138 ++++++++++++++++++++++++++----------------
 1 file changed, 85 insertions(+), 53 deletions(-)

-- 
2.27.0

