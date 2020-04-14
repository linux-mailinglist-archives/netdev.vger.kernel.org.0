Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444681A78A3
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 12:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438537AbgDNKna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 06:43:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42153 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2438507AbgDNKm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 06:42:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586860946;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XIJFty4A7/x7MXrExzV9BBal3iymPjuyPXQKR8dThbY=;
        b=TnRa9LLIFb8wCYHdErzMMq07P/Y0ta0VRgMyndcgh4kBhkdqkR7znErLhHd6HGgFvOFUFT
        Xt9V5NwhhkYORkm9bb1J5Yee2LeI3RQQLRJyoLfYZCRLcPfRMra2mP4VySs3r+mnkX2HwA
        dyjrgClkfgY7gMEMrdtRdcq6pGXkKB0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-z82y5mbfOcmUvhsWElBrAA-1; Tue, 14 Apr 2020 06:42:22 -0400
X-MC-Unique: z82y5mbfOcmUvhsWElBrAA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 10154802560;
        Tue, 14 Apr 2020 10:42:21 +0000 (UTC)
Received: from ovpn-113-222.ams2.redhat.com (ovpn-113-222.ams2.redhat.com [10.36.113.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A13F6092D;
        Tue, 14 Apr 2020 10:42:18 +0000 (UTC)
Message-ID: <66c3db9b1978a384246c729034a934cc558b75a6.camel@redhat.com>
Subject: Re: WARNING in hwsim_new_radio_nl
From:   Paolo Abeni <pabeni@redhat.com>
To:     syzbot <syzbot+a4aee3f42d7584d76761@syzkaller.appspotmail.com>,
        davem@davemloft.net, johannes@sipsolutions.net,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date:   Tue, 14 Apr 2020 12:42:17 +0200
In-Reply-To: <000000000000bb471d05a2f246d7@google.com>
References: <000000000000bb471d05a2f246d7@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master

I don't see why the bisection pointed to the MPTCP commit ?!? the
following patch should address the issue.
---
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7fe8207db6ae..2082abdb08d4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -635,7 +635,8 @@ static const struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
        [HWSIM_ATTR_SUPPORT_P2P_DEVICE] = { .type = NLA_FLAG },
        [HWSIM_ATTR_USE_CHANCTX] = { .type = NLA_FLAG },
        [HWSIM_ATTR_DESTROY_RADIO_ON_CLOSE] = { .type = NLA_FLAG },
-       [HWSIM_ATTR_RADIO_NAME] = { .type = NLA_STRING },
+       [HWSIM_ATTR_RADIO_NAME] = { .type = NLA_STRING,
+                                   .len = NL80211_WIPHY_NAME_MAXLEN },
        [HWSIM_ATTR_NO_VIF] = { .type = NLA_FLAG },
        [HWSIM_ATTR_FREQ] = { .type = NLA_U32 },
        [HWSIM_ATTR_TX_INFO_FLAGS] = { .type = NLA_BINARY },

