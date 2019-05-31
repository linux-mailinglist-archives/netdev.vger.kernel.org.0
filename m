Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE313062C
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 03:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfEaBR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 21:17:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33235 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfEaBR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 21:17:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id h17so3043324pgv.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 18:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=lqXIB5VYrvs6jzaa1g5z58dzubUn6chXga4pIoclBMk=;
        b=AXivDdUXnwZ3DRv77pdpJFBVOOGHV1N7WPHdh9KEJTOWB3mZHDRvAnvsgTK02YurLB
         vnM1t3CvOCRY5Bk/K9EAvON7MrmcrcdjRV8WyVkSRwh1QVtmWXEbTPR/LuREG/7IRHNM
         vizi3cLSebt1yXXSvgW3YrJmFYDVya3Pdf0EvelPlIUSvOX9dVqYrvRyiIGXkmqd1CEl
         HtLEqvoVqfMhZrpIx/ReMAgY0822LS5+V6sOYtSSsfN/G2aviSY/y7laA2a/zM20uOwF
         wnBVbIq4UFV22XROuPjXI1gQ20y+6FC1nBDuha4RERDo8jynH7+WXL4Dk6xvNWWmCvmL
         zI6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lqXIB5VYrvs6jzaa1g5z58dzubUn6chXga4pIoclBMk=;
        b=gea9DITTJX1wYjDdPuaJSUqZ1rmojBZ+zGq5ANenFvmXqS1xSQ7wQL9MZZSljXnZVR
         awAGAhZf1hxhMg9m8m3uZSMkFq3m1IZD0brWi+uyBxSAQofm/dlpOrsCsZNs68044Au2
         YWAfRuSOY1qf1Cp+DbxpDbGX53Dcp3fxsnGVRecx+CjJ9KdItPMox78yuiPrgQWOK++k
         UdvSMTLeWVVEv3dzcQiAFMkCVsLQlNA07rze6RRdev5Dwk52PARudFnbB3kVSYfXdaSO
         X9AXPQhMf5Hrk75boKhiFbVWNTj3wy6Xs1xgHysPl/5SHekPAImAmD3hdtkhJ1dsyxWF
         swNg==
X-Gm-Message-State: APjAAAURdkQtZqhyFvnnOKDHFhthbYLByUuOHOTp+SVJ0sg4X9Ye/F9B
        oY5giDp3F6P81e4hG48IoviWZhreHYI=
X-Google-Smtp-Source: APXvYqwhmKCBjnssnPJFBip10hmLkNMYYCUmPPrBrlyQG6qHzxD+sqJ+lptQQWwYUYt4XCmVMKfY/A==
X-Received: by 2002:a63:ed16:: with SMTP id d22mr6374376pgi.35.1559265477220;
        Thu, 30 May 2019 18:17:57 -0700 (PDT)
Received: from localhost.localdomain (104-188-17-28.lightspeed.sndgca.sbcglobal.net. [104.188.17.28])
        by smtp.gmail.com with ESMTPSA id j20sm1819042pff.183.2019.05.30.18.17.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 18:17:56 -0700 (PDT)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Arun Kumar Neelakantam <aneela@codeaurora.org>,
        Chris Lew <clew@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 0/5] QRTR flow control improvements
Date:   Thu, 30 May 2019 18:17:48 -0700
Message-Id: <20190531011753.11840-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.18.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to prevent overconsumption of resources on the remote side QRTR
implements a flow control mechanism.

Move the handling of the incoming confirm_rx to the receiving process to
ensure incoming flow is controlled. Then implement outgoing flow
control, using the recommended algorithm of counting outstanding
non-confirmed messages and blocking when hitting a limit. The last three
patches refactors the node assignment and port lookup, in order to
remove the worker in the receive path.

Bjorn Andersson (5):
  net: qrtr: Move resume-tx transmission to recvmsg
  net: qrtr: Implement outgoing flow control
  net: qrtr: Migrate node lookup tree to spinlock
  net: qrtr: Make qrtr_port_lookup() use RCU
  net: qrtr: Remove receive worker

 net/qrtr/qrtr.c | 308 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 239 insertions(+), 69 deletions(-)

-- 
2.18.0

