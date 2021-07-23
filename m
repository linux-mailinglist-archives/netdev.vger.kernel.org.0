Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CAD53D36E3
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234540AbhGWH53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhGWH52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:57:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B05C061575;
        Fri, 23 Jul 2021 01:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Obk6U+ay+sgJKpQCJECzXauTigDtAdD5YjEfRLDjgZw=;
        t=1627029481; x=1628239081; b=u7Ax3Yfch2go1+9IrDAoBy4M7xiYnOU6I9tStZ3+nLi9QHF
        M7y/0KaDoUidVY8s2XDMAxbfiz29syLv3fdjSighb7P4Z64rXZo06aZGcF6VSnHTqsicdb+bcjM3P
        0eomAYt1HcBqpLkL0zg6rFE+wkc1oPFvGu0QUHyMQhi9zK7ENfIRqLcxd2HApL4psiKRZfHRIm97q
        t3MCje3nZb21hVYKGU1TQvvrj8t8nFZgM6p1HHcWFznmf1zaiqbitobCr8i4lGMZNQ5/9YYvl4nif
        PaGHS99xuIIwlJiUSi3l9EuRp3TMK+lqP2JSmUZyOjv9IGoqPVmpB2QUZXJq+T7A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m6qeC-000T4h-Vr; Fri, 23 Jul 2021 10:37:47 +0200
Message-ID: <d2b0f847dbf6b6d1e585ef8de1d9d367f8d9fd3b.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: free the object allocated in
 wiphy_apply_custom_regulatory
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>
Cc:     syzbot+1638e7c770eef6b6c0d0@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 23 Jul 2021 10:37:45 +0200
In-Reply-To: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
References: <20210723050919.1910964-1-mudongliangabcd@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-07-23 at 13:09 +0800, Dongliang Mu wrote:
> The commit beee24695157 ("cfg80211: Save the regulatory domain when
> setting custom regulatory") forgets to free the newly allocated regd
> object.

Not really? It's not forgetting it, it just saves it?

+       new_regd = reg_copy_regd(regd);
+       if (IS_ERR(new_regd))
+               return;
+
+       tmp = get_wiphy_regdom(wiphy);
+       rcu_assign_pointer(wiphy->regd, new_regd);
+       rcu_free_regdom(tmp);

> Fix this by freeing the regd object in the error handling code and
> deletion function - mac80211_hwsim_del_radio.

This can't be right - the same would affect all other users of that
function, no?

Perhaps somewhere we have a case where wiphy->regd is leaked, but than
that should be fixed more generally in cfg80211?

johannes

