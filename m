Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9974E21A67C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 20:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgGISAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 14:00:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41519 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726837AbgGISAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 14:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594317617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSmHCYqTJaSTXfFEyJ7QznommGakcBgIZIjtaK6txxQ=;
        b=O5PQeg/O7opDO7Uc5Er9sq8Jc74ytBbWtnPskvVrGIxWMyKg6rWLmNIwvsEmc+QU13YZh5
        hX1cGoNanA991WZIKB7DSfJeELCi3dntdKaQehfIN6mJZF1jerHBJJxZooP8KXrOiIVtsP
        M1CKlCTUxEQlzqakruGag2QbKd2vP2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-Iyo0Fi75MsuOsRR_pEcEXA-1; Thu, 09 Jul 2020 14:00:13 -0400
X-MC-Unique: Iyo0Fi75MsuOsRR_pEcEXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D372100CCC0;
        Thu,  9 Jul 2020 18:00:12 +0000 (UTC)
Received: from ovpn-113-239.ams2.redhat.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD9126FEE9;
        Thu,  9 Jul 2020 18:00:10 +0000 (UTC)
Message-ID: <9c10bd38adebd1d83bfa03545ec2db34ec2b56e8.camel@redhat.com>
Subject: Re: [PATCH net-next 3/4] mptcp: add MPTCP socket diag interface
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 09 Jul 2020 20:00:09 +0200
In-Reply-To: <20200709103405.0075678b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1594292774.git.pabeni@redhat.com>
         <7f9e6a085163dcb0669b9dd8aace1c62373279db.1594292774.git.pabeni@redhat.com>
         <20200709103405.0075678b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-07-09 at 10:34 -0700, Jakub Kicinski wrote:
> On Thu,  9 Jul 2020 15:12:41 +0200 Paolo Abeni wrote:
> > exposes basic inet socket attribute, plus some MPTCP socket
> > fields comprising PM status and MPTCP-level sequence numbers.
> > 
> > Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> Any idea why sparse says this:
> 
> include/net/sock.h:1612:31: warning: context imbalance in 'mptcp_diag_get_info' - unexpected unlock
> 
> ? 🤨

AFAICS, that is a sparse false positive, tied
to unlock_sock_fast() usage. 

unlock_sock_fast() conditionally releases the socket lock, according to
it's bool argument, and that fools sparse check: any unlock_sock_fast()
user splats it.

IMHO such warning should be addressed into [un]lock_sock_fast()
function[s] - if possible at all. Outside the scope of this series.

Matthieu suggested adding some comment to note the above, but I boldly
opposed, as current unlock_sock_fast() users don't do that.

Cheers,

Paolo



