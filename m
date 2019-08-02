Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF9D8009A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391296AbfHBTC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:02:26 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:45374 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391054AbfHBTCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:02:25 -0400
Received: by mail-oi1-f194.google.com with SMTP id m206so57603098oib.12
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 12:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zusammenkunft-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=VrKh/E2ayUxjWwVDUW+HY6xwi4A/jx7/xaGJ36HlTmM=;
        b=VHyCHWzzJ5r6oZ0TiwTqicY6B4UxGzeNeyzBmpAo5wnnELzF0RmDfyeqFjNQgZ9HUW
         EcwKiKgLkfGw6hHofrqQmG4puUGi69GxAJlIc0li8F7m8bOTQxRLiHcIYX8dLn1QBSX4
         QlqzJ5s8uTN1dmgF6U6l9m1dlp+7wra4z5WYCNsLjumOX0Uds4Q4I7ZlJmt8CsHYSz1D
         0y2j1E2UxN4bweKfwm0ELG1prcRTyQvZbvOUp1pImSWQRJxtV+/SDt6an0+p8RSkQTnk
         CSxiLq5NnHyBiFEW5CB6kupg+JGrKWYN61ee1Je2fMbsuROCKlr2KNhnnXLm4EyQpL1N
         DDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=VrKh/E2ayUxjWwVDUW+HY6xwi4A/jx7/xaGJ36HlTmM=;
        b=W/qv2oJCljjdzKpNgX4Ri82J1bjWV07NFpGgFVzBxuDcgYJH/Z7Ys66UjrUlEPNPgT
         jD2cK8ELgmKD53meb/XPo6afwB8oWF1WfRPY+vGIlPYUQ2uDkJ7e0sQBU6JKhL91+SIi
         +Q9IO8Jy81M1F2UInOPsRurJEbiC80rKPaCNFQc/nG+tf2Gzpa1KxHBPkc6ov/iyHlKd
         WAa68pS4RmTaQRLFNvFMlxu/b9V3Wzmk9RuT8zkpXzPZTObRL6eknWJTRaPqyeZW2F30
         Br1EmpqBl4UiQWTrwZ7M6OB+r6wuG6fVH9LM7QeTT8YYAlx6IRQ67lca2jb0EwEmOTPP
         YT5Q==
X-Gm-Message-State: APjAAAWOp2FCKMajreGwCdNVkSCa+0W3yusdqjQx31UqpkBo/hAwxocA
        SlMju1XjscZvkESmPvLdEO3nLAsfiPZUwpxrfS5tbWYfl60=
X-Google-Smtp-Source: APXvYqx9bAa0HiuvvPI6El2rBzH56kVa/f0a7AIXNCJUzFk5d228Ho2To33sPldJzSG/kinQyKkb6RFaeRL7x5c8CoI=
X-Received: by 2002:a54:4f09:: with SMTP id e9mr3680783oiy.89.1564772543943;
 Fri, 02 Aug 2019 12:02:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:41d5:0:0:0:0:0 with HTTP; Fri, 2 Aug 2019 12:02:23 -0700 (PDT)
From:   Bernd <ecki@zusammenkunft.net>
Date:   Fri, 2 Aug 2019 21:02:23 +0200
Message-ID: <CABOR3+yUiu1BzCojFQFADUKc5BT2-Ew_j7KFNpjP8WoMYZ+SMA@mail.gmail.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory limits
To:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

While analyzing a aborted upload packet capture I came across a odd
trace where a sender was not responding to a duplicate SACK but
sending further segments until it stalled.

Took me some time until I remembered this fix, and actually the
problems started since the security fix was applied.

I see a high counter for TCPWqueueTooBig - and I don=E2=80=99t think that=
=E2=80=99s an
actual attack.

Is there a probability for triggering the limit with connections with
big windows and large send buffers and dropped segments? If so what
would be the plan? It does not look like it is configurable. The trace
seem to have 100 (filled) inflight segments.

Gruss
Bernd
--=20
http://bernd.eckenfels.net
