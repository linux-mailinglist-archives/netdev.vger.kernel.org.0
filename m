Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF522BC2D9
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 09:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440598AbfIXHln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 03:41:43 -0400
Received: from mail-qt1-f179.google.com ([209.85.160.179]:45315 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408088AbfIXHln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 03:41:43 -0400
Received: by mail-qt1-f179.google.com with SMTP id c21so1001667qtj.12
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 00:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6IWRKElUnLluF0V3Zp3dUnnX6RBR9DXvVw5Kgj2zIIQ=;
        b=kW0dEaIZdVjswRVH1IpYhgFPqTrp4IfebpebZBvZ39BAvBX6Kw8ptTxFnNAdeKdP6u
         KnlWnpZ6nt8BFiypzFh5NCK0n0e8FOhitjt0+u37ttGJyF2cgT83TIkGUrPh5pRsYep6
         uPNRNZbrPFmgTetSNe8VGEY5smEsHMheyQujPTulLAfiP8Ac36vkbT9zIlRFEQ2rNmH0
         ohxMdthOrwrXBYsbwGb2Loxnazy6HpiM81k/dV7kOXiKzspl/vpMgsWut+3kpOLhVjKC
         4KV7cXECWROuz4phRX6Wqmh3vywmuhwrBOSid0u356WjBaouh4dhak+2BmzXvq1M8Jsi
         aaTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6IWRKElUnLluF0V3Zp3dUnnX6RBR9DXvVw5Kgj2zIIQ=;
        b=uUiefL8zEKk8+0uNtaUMUbn2wKcY+sgjRhac3g+2+gBXijWkV02DnN+ha/h7MYEzeS
         Niy8WPUJb0vChGDJxqyRXbC9xE2o5s2lsVV2XbiJ9aSGw/fLqcnRfA71yaDVFvRsbAP9
         Eb/2iSi14HG7RFwEaYC4Z7Nz+3jnEhvQxCy1iXgFPGi6oH3PPCUZe5vqeRUDIZpgZC7G
         NnrAqRTsZ/4d7mrnmjV5Hp0tBP5IT6WLqjYgq3ULO2eefS5CDZHiVhy1vK23jbhHqK3/
         iCqlfDCJpKFT3UASZYsIG3gZXSTM5G7c9h6mPULnjQaFspUttex3eblrlMSRSUPRCHqV
         uUdQ==
X-Gm-Message-State: APjAAAUNOO9WYXm7bpe2/PNLzuxW2eE+IXzRwuCwsoAtw2i8TFqRDtOl
        dzGubL55/ArIpOcCs17nlAfMnTxlqL+HsTtZES7GtnSu
X-Google-Smtp-Source: APXvYqzfGHHqixxcBsH5E273EqH5MIE7W3/8ZQYYw8wL7v8iIBD0VzmdegE4YlKox9IVZQOZN+rtnTugqpvadVcp1gY=
X-Received: by 2002:a05:6214:582:: with SMTP id bx2mr1313077qvb.60.1569310902452;
 Tue, 24 Sep 2019 00:41:42 -0700 (PDT)
MIME-Version: 1.0
From:   Qiwei Wen <wenqiweiabcd@gmail.com>
Date:   Tue, 24 Sep 2019 17:41:31 +1000
Message-ID: <CADxRGxCkw=q0i9U1j52wwbW5OJJoU9P_RT4_Mh3AeMmDhEQVmA@mail.gmail.com>
Subject: ethtool 5.2 qsfp.c heap buffer overflow
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The function "sff8636_dom_parse", called from "sff8636_show_dom",
disregards the module eeprom size returned from the driver and assumes
the existence of upper pages, e.g.

sd->sfp_temp[HALRM] = SFF8636_OFFSET_TO_TEMP(SFF8636_TEMP_HALRM);

To reproduce: return ETH_MODULE_SFF_8636_LEN (256) for module eeprom
length in NIC driver, compile ethtool 5.2 with clang and address
sanitizer linked in, run ethtool -m.

Best regards,
Dave
