Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D65354942
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 01:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241827AbhDEXdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 19:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbhDEXdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 19:33:37 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E36C061788
        for <netdev@vger.kernel.org>; Mon,  5 Apr 2021 16:33:29 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n13so18627681ybp.14
        for <netdev@vger.kernel.org>; Mon, 05 Apr 2021 16:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=to6Vxja+Arjc3jgF2y75CIMjsTw24v2WgNqXzBAN2G4=;
        b=jEYZqFK4qYXZjXqxm8kJnUCJ/HGf/4pQIRB3IfRcS9nSXWq37L5cg4Hi2cjXeoec+Y
         QnyrSCmtSZLs/Wo+mR1kcl0lYR1DdUH485SifgpfypYPOhxj9SOOkLl5fZZ4tsAIQ9Qf
         rDIgDY5ZuSYQt3oPjxqLelVRZdVuEfncudKq9I++0cqVs9dEy1LV5rCOV698B0jjw4J5
         CI39vHBdXuePVt9HTbWvUfu/6q6I4jfkGC/jm8Hx/STZPVNilKzwWk3DvjDaHzxLqAEX
         emx3YEzYVMaedIFqzd3/NrmWhZNUOa/AQb1U60F1GLzo9Bfpp6VOWQ8til8ccyzxFDBD
         woDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=to6Vxja+Arjc3jgF2y75CIMjsTw24v2WgNqXzBAN2G4=;
        b=jNEy7GVaI7FU3n6m3UI1eiP/yN3YfK9dBfpfwOSzMKGk1hrK9uztyavBXeAHLibSJv
         YLi9HuobVWI69TbOEeWHNA7agJ2NKuBHbj7XlsaeaBJT0ariEBv05oMsxf9yDbdqqN9v
         1lgUI0Om934VYHLyIwnaMbGeOLXIKgGK9Hw0WpjD7EbNAJU6shTFhbwcuJA1KJLqDGI3
         Mkm8uPsDkaa+1R2lSUHPx5MWIKq/ta4FwryFkd8i9gWN//Mhy+51wH2teMvZMt9BHu2/
         ii3mYawP440mKe2cegvwPJlHgogQ+O0V/pC38qM/6EsAAyV1BiC/Q4QWzRWgDim6PRUn
         nO2Q==
X-Gm-Message-State: AOAM531K3ePHEMi1BGLHfgZBjGUu4xXFNR7v8DSm46aFUKNIKh2ki5kR
        D/SV4qwGdmTewxviLhkCze4O7vLErtbVF4EQn/IZ
X-Google-Smtp-Source: ABdhPJxACUkz/6Pr+kJuu/6e3/KOIdlQcw8bE7vaqlYhTWwjONXYmo90PEfWYGytXsD0uf87TrfxIxGk2snIXjvSmRN5
X-Received: from danielwinkler-linux.mtv.corp.google.com ([2620:15c:202:201:1cb3:ad22:2ed6:7c62])
 (user=danielwinkler job=sendgmr) by 2002:a5b:448:: with SMTP id
 s8mr37252543ybp.363.1617665608348; Mon, 05 Apr 2021 16:33:28 -0700 (PDT)
Date:   Mon,  5 Apr 2021 16:33:05 -0700
In-Reply-To: <20210405233305.92431-1-danielwinkler@google.com>
Message-Id: <20210405162905.2.Iaac4fb40841e46f9ab815bffee439c91e44f0639@changeid>
Mime-Version: 1.0
References: <20210405233305.92431-1-danielwinkler@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH 2/2] Bluetooth: Do not set cur_adv_instance in adv param MGMT request
From:   Daniel Winkler <danielwinkler@google.com>
To:     marcel@holtmann.org, linux-bluetooth@vger.kernel.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Daniel Winkler <danielwinkler@google.com>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We set hdev->cur_adv_instance in the adv param MGMT request to allow the
callback to the hci param request to set the tx power to the correct
instance. Now that the callbacks use the advertising handle from the hci
request (as they should), this workaround is no longer necessary.

Furthermore, this change resolves a race condition that is more
prevalent when using the extended advertising MGMT calls - if
hdev->cur_adv_instance is set in the params request, then when the data
request is called, we believe our new instance is already active. This
treats it as an update and immediately schedules the instance with the
controller, which has a potential race with the software rotation adv
update. By not setting hdev->cur_adv_instance too early, the new
instance is queued as it should be, to be used when the rotation comes
around again.

This change is tested on harrison peak to confirm that it resolves the
race condition on registration, and that there is no regression in
single- and multi-advertising automated tests.

Reviewed-by: Miao-chen Chou <mcchou@chromium.org>
Signed-off-by: Daniel Winkler <danielwinkler@google.com>
---

 net/bluetooth/mgmt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 09e099c419f251..59f8016c486626 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -7979,7 +7979,6 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	hdev->cur_adv_instance = cp->instance;
 	/* Submit request for advertising params if ext adv available */
 	if (ext_adv_capable(hdev)) {
 		hci_req_init(&req, hdev);
-- 
2.31.0.208.g409f899ff0-goog

