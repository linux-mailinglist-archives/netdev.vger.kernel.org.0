Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D453FA7BD
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 23:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbhH1V7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 17:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbhH1V7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 17:59:38 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A80BC061756
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:58:47 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id h9so22038843ejs.4
        for <netdev@vger.kernel.org>; Sat, 28 Aug 2021 14:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=iqFaHhr+uhTni4oJ8D5ocjXl0dGyvdZYXl0ZFwoYNzs=;
        b=Lq1/xOqOdvCvxNTtkPb6lwRQm272pkOL5BqdRBRtXhf6JHVaDws2SXjH9JXZVx65O0
         QfrUJ1uhpnJ6mu98AAGvrwr65fjg6m8QhHnhyb2Np/dNi/sUDYyQdTIGFlRKDG5s6luT
         7F/l90C6hpkw6cjfVzHgZ3DLlSetppUMNOFmA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iqFaHhr+uhTni4oJ8D5ocjXl0dGyvdZYXl0ZFwoYNzs=;
        b=Og2b9mXnitRMv+9OXeRjTWxbxn6cPq/bAaMLDXkbcoiKFuP63azYreQNdBXhZ0On0e
         tqtXDZzEtKEF9F4hWT5ReJFTBCAGtlqVZNVNmKVwHNzwBCJKJMNHPz8dA77trZDa9M1W
         d65i9ZquIcf9Rz+3k8RWSe75rzKfRuMbyFI5gigbz8T4Qf3Ssm/FXZdBs+5ASo3xXtt3
         7oPh4eJEnUlyoERQ1fuxQUOO1uJo/Ez+OBrJVXJq7MDlJngcWFyl4wc9DDS6Encsbkpv
         +1I9m45OmWXh5z2HueNdLi1meZ3wmcFcAY1SPtyM4fyZzObwEreHMiV++2E2IZz9sbAI
         /XrA==
X-Gm-Message-State: AOAM5334ocb/I4m1lDah8b26NnA8oklJ6SoBTkOfe5BuDg0dHeQBm244
        aU8j/3NygVHuw5XJe74Tv8DM9w==
X-Google-Smtp-Source: ABdhPJzCYOFYn/PGWDy3hFoKYAzYcLBIaX5g5zD9kZxzKQO3TudnGKwxowgysujn1DmpEJHU+0Vp8w==
X-Received: by 2002:a17:906:4c42:: with SMTP id d2mr17110840ejw.301.1630187925692;
        Sat, 28 Aug 2021 14:58:45 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id cf11sm5361239edb.65.2021.08.28.14.58.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 28 Aug 2021 14:58:44 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net-next 00/11] bnxt_en: Implement new driver APIs to send FW messages
Date:   Sat, 28 Aug 2021 17:58:19 -0400
Message-Id: <1630187910-22252-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004215fe05caa5b4dc"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004215fe05caa5b4dc

The current driver APIs to send messages to the firmware allow only one
outstanding message in flight.  There is only one buffer for the firmware
response for each firmware channel.  To send a firmware message, all
callers must take a mutex and it is released after the firmware response
has been read.  This scheme does not allow multiple firmware messages
in flight.  Firmware may take a long time to respond to some messages
(e.g. NVRAM related ones) and this causes the mutex to be held for
a long time, blocking other callers.

This patchset intoduces the new driver APIs to address the above
shortcomings.  All callers are then updated to use the new APIs.

Edwin Peer (11):
  bnxt_en: remove DMA mapping for KONG response
  bnxt_en: Refactor the HWRM_VER_GET firmware calls
  bnxt_en: move HWRM API implementation into separate file
  bnxt_en: introduce new firmware message API based on DMA pools
  bnxt_en: discard out of sequence HWRM responses
  bnxt_en: add HWRM request assignment API
  bnxt_en: add support for HWRM request slices
  bnxt_en: use link_lock instead of hwrm_cmd_lock to protect link_info
  bnxt_en: update all firmware calls to use the new APIs
  bnxt_en: remove legacy HWRM interface
  bnxt_en: support multiple HWRM commands in flight

 drivers/net/ethernet/broadcom/bnxt/Makefile   |    2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 2129 ++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  101 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_dcb.c |  185 +-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c |   81 +-
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  548 +++--
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.c    |  763 ++++++
 .../net/ethernet/broadcom/bnxt/bnxt_hwrm.h    |  145 ++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c |  130 +-
 .../net/ethernet/broadcom/bnxt/bnxt_sriov.c   |  457 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |  264 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |   31 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c |   62 +-
 13 files changed, 2901 insertions(+), 1997 deletions(-)
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
 create mode 100644 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h

-- 
2.18.1


--0000000000004215fe05caa5b4dc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJisJUvwYShy0Jf6dr7c14mCgxWQ1oPg
NYfNGsax7fV7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgy
ODIxNTg0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAE7eeEE4SIjS9Pwv+KeAq8/OWW5PPiZ6aFZd9t5BVMDFU0ckfc
CattxIEFQCXDlUoEKJ2qzVjc2YXMSl5X89MtFPHHwd24NugVzh7cIsc+fRFU0zizUKHA5Jcrb5jq
508SykyuwqupIeWOL0qsflTVACXV/UPo+TaqtnX4nPtJ5Vicn9rv8d+GJGT1XSCeX8jnY3fNbbu1
19vtRCq2/qGEcJfR5Bin8l46mHKT8IJPdK5ZbyaRHVX4aJZASIL4L+2ofDjqwgjhc5RFH6IDG+ea
plwvZq+serodc9jnVLtOMEIIjZ7IqFxMCEyiSSxDO95SthWkzUeRdl76Nxup+btO
--0000000000004215fe05caa5b4dc--
