Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B83675FF3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 23:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjATWMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 17:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjATWMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 17:12:36 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFCE3644A
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:12:34 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id r71so3115357iod.2
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 14:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=cc:to:message-id:date:content-transfer-encoding:mime-version
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=U1Ao9NXaWgBOUiK+rj9v9X8Q1xZNi+V9uTD46WKKtdw=;
        b=CP69oNJLnjiVV4tB0rYNSmBoYhq8zTAf5aeWGwBovXoy78p1YHNttTfFLpgUdkZt5y
         CF6BkjRK5BXmetvzcOipE6ZWALHWD4fDKhxrzQDRZETLKzd8lYiiMlj8HPAiBZDkBq+1
         Fjdww4iDsWbfzKLRwjC85+Yo6BGDTWL5y5Tv4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:message-id:date:content-transfer-encoding:mime-version
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U1Ao9NXaWgBOUiK+rj9v9X8Q1xZNi+V9uTD46WKKtdw=;
        b=IpWYRK5AP8xC4flvCEXZz429eyymcsauV3YGnSfs2+x4WBvuBvT3KKBOhuqZU/buPQ
         61re4MywJNjleiM2ZjPyMGJcbtI8ZiuD/brZnQ5tjRM9AUw6sHDab1v6yqitOOIoq1zz
         w1+KbJ3r7PqYB9oW7XcVYdNHr22r0LI4iQjffzOZXrc2/Hkzf5uNOyz8PxZ3AHSQAGDt
         fXAsQwozHfRFnCZ74VlAup5K/dOnyvMdt7uXUQZhdfNpOaro5PtV+b1c3esyuuqfPY5n
         qqQARRRxdBp8GRXPFHuGNkrXvln1kWUvIdN4f9uLrLbjr5IeIro+yHDU8dUyNrTJi8Z7
         r8ng==
X-Gm-Message-State: AFqh2koBunZE9sqc2mxNtLPzvH3ognlyi+9VZkS7VKSssFKcRdPzrwsi
        1zZ1Tf7EqYH1U3ttX+ZEULB9LA==
X-Google-Smtp-Source: AMrXdXum9CTPzdCUTloBWrH1lZInZCJwTTZUYqpFqr+e9Y/2n3mTCcLg6hp+gsZAesCShxp7/GqsWA==
X-Received: by 2002:a6b:500a:0:b0:705:5e1e:eb6e with SMTP id e10-20020a6b500a000000b007055e1eeb6emr9205488iob.11.1674252753715;
        Fri, 20 Jan 2023 14:12:33 -0800 (PST)
Received: from localhost ([136.37.131.79])
        by smtp.gmail.com with ESMTPSA id cs8-20020a056638470800b003a7cadffda7sm1519487jab.2.2023.01.20.14.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 14:12:33 -0800 (PST)
From:   "Seth Forshee (DigitalOcean)" <sforshee@digitalocean.com>
X-Google-Original-From: "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>
Subject: [PATCH 0/2] vhost: improve livepatch switching for heavily loaded vhost worker kthreads
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-b4-tracking: H4sIAMQRy2MC/w3LOw6AIAwA0KuYzjZBWNTbFGykkVRD/QzGu8v4hveCcRU2mLsXKt9ismvD0HeQMu
 nKKEszeOeDG7zDO+924lYOtEfOlEVXjDRRIA5jHAnajGSMsZKm3K5epXzfD5ena69qAAAA
Date:   Fri, 20 Jan 2023 16:12:20 -0600
Message-Id: <20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org>
To:     Petr Mladek <pmladek@suse.com>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        "Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
        netdev@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.10.1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2416; i=sforshee@kernel.org;
 h=from:subject:message-id; bh=EZbjAIdznm3Oej+eWIGyRgmoqSdbR0GomfdbWyUvWuE=;
 b=owEBbQGS/pANAwAKAVMDma7l9DHJAcsmYgBjyxHK47dK5XiK+U7PMs1DUY+EH512EmtrWsinE62O
 st1NWfiJATMEAAEKAB0WIQSQnt+rKAvnETy4Hc9TA5mu5fQxyQUCY8sRygAKCRBTA5mu5fQxySm3B/
 9RzhyLuYXteP+GKtAYPSH91mkV9to22qctt0HVI4O7jF/xfnsSaW4H0H02HzXQL4C8vk9TICOgCpWM
 pXpuuKMmpauwn5I88hvtmnChrAtfuwXV9F/UZOx/bcGLSB0XyBo6ZeZhGFtiBSptCzz8vAjY181OnP
 DAN50d3RjfNYScU+jrA3MfX9R0/PfKs71zuNpV02R961kdFFUwIS/tPPHJHkElpqV/jm9BLIkCYle/
 Bwg0bcI2xNiyjrSUqq5rr8jayRwWFBpLFlz3HgMSaIugOyfVtjr2ZTXwNjwmvhBPu7+KsrMWT/MUWO
 5AS2iykCZxhYrlFLHs79+KNjXkreR5
X-Developer-Key: i=sforshee@kernel.org; a=openpgp;
 fpr=2ABCA7498D83E1D32D51D3B5AB4800A62DB9F73A
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We've fairly regularaly seen liveptches which cannot transition within kpatch's
timeout period due to busy vhost worker kthreads. In looking for a solution the
only answer I found was to call klp_update_patch_state() from a safe location.
I tried adding this call to vhost_worker(), and it works, but this creates the
potential for problems if a livepatch attempted to patch vhost_worker().
Without a call to klp_update_patch_state() fully loaded vhost kthreads can
never switch because vhost_worker() will always appear on the stack, but with
the call these kthreads can switch but will still be running the old version of
vhost_worker().

To avoid this situation I've added a new function, klp_switch_current(), which
switches the current task only if its stack does not include any function being
patched. This allows kthreads to safely attempt switching themselves if a patch
is pending. There is at least one downside, however. Since there's no way for
the kthread to track whether it has already tried to switch for a pending patch
it can end up calling klp_switch_current() repeatedly when it can never be
safely switched.

I don't know whether this is the right solution, and I'm happy to try out other
suggestions. But in my testing these patches proved effective in consistently
switching heavily loaded vhost kthreads almost immediately.

To: Josh Poimboeuf <jpoimboe@kernel.org>
To: Jiri Kosina <jikos@kernel.org>
To: Miroslav Benes <mbenes@suse.cz>
To: Petr Mladek <pmladek@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>

---
Seth Forshee (DigitalOcean) (2):
      livepatch: add an interface for safely switching kthreads
      vhost: check for pending livepatches from vhost worker kthreads

 drivers/vhost/vhost.c         |  4 ++++
 include/linux/livepatch.h     |  2 ++
 kernel/livepatch/transition.c | 11 +++++++++++
 3 files changed, 17 insertions(+)
---
base-commit: 5dc4c995db9eb45f6373a956eb1f69460e69e6d4
change-id: 20230120-vhost-klp-switching-ba9a3ae38b8a

Best regards,
-- 
Seth Forshee (DigitalOcean) <sforshee@kernel.org>
