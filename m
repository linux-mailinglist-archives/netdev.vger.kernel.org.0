Return-Path: <netdev+bounces-2919-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A15AF70483A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D58128141B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DC81C26;
	Tue, 16 May 2023 08:53:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADAE2C72E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:53:43 +0000 (UTC)
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0385FB8
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:53:41 -0700 (PDT)
Received: from mail-auth.avm.de (unknown [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 16 May 2023 10:53:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1684227220; bh=VV1aTdyRlYF0Cbqz2Q4oeSsJ1iE3UDM6RxDiJvHQWZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V2oN7ldNczSlpbtWCZKEcWHJ7KbrE5gfu6ksiQH/HrqRedg7F/Wvb20SMAyL8P7WA
	 xgGIt/Nl9oylPWMFzXwJqtYtijBQLKFcJgfzk6nOr7cKqLVltrP4mohekm5IOl7Ve0
	 pjH74daLXHb/ZXSR1Kfv84mwWAvfV+V3Xhj74aGY=
Received: from localhost (unknown [172.17.88.63])
	by mail-auth.avm.de (Postfix) with ESMTPSA id E5B1C80C0E;
	Tue, 16 May 2023 10:53:39 +0200 (CEST)
Date: Tue, 16 May 2023 10:53:39 +0200
From: Johannes Nixdorf <jnixdorf-oss@avm.de>
To: Nikolay Aleksandrov <razor@blackwall.org>
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Message-ID: <ZGNEk3F8mcT7nNdB@u-jnixdorf.ads.avm.de>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <a1d13117-a0c5-d06e-86b7-eacf4811102f@blackwall.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a1d13117-a0c5-d06e-86b7-eacf4811102f@blackwall.org>
X-purgate-ID: 149429::1684227220-F5C5C84B-E96B91CE/0/0
X-purgate-type: clean
X-purgate-size: 3999
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 11:38:11AM +0300, Nikolay Aleksandrov wrote:
> On 15/05/2023 11:50, Johannes Nixdorf wrote:
> > A malicious actor behind one bridge port may spam the kernel with packets
> > with a random source MAC address, each of which will create an FDB entry,
> > each of which is a dynamic allocation in the kernel.
> > 
> > There are roughly 2^48 different MAC addresses, further limited by the
> > rhashtable they are stored in to 2^31. Each entry is of the type struct
> > net_bridge_fdb_entry, which is currently 128 bytes big. This means the
> > maximum amount of memory allocated for FDB entries is 2^31 * 128B =
> > 256GiB, which is too much for most computers.
> > 
> > Mitigate this by adding a bridge netlink setting IFLA_BR_FDB_MAX_ENTRIES,
> > which, if nonzero, limits the amount of entries to a user specified
> > maximum.
> > 
> > For backwards compatibility the default setting of 0 disables the limit.
> > 
> > All changes to fdb_n_entries are under br->hash_lock, which means we do
> > not need additional locking. The call paths are (✓ denotes that
> > br->hash_lock is taken around the next call):
> > 
> >  - fdb_delete <-+- fdb_delete_local <-+- br_fdb_changeaddr ✓
> >                 |                     +- br_fdb_change_mac_address ✓
> >                 |                     +- br_fdb_delete_by_port ✓
> >                 +- br_fdb_find_delete_local ✓
> >                 +- fdb_add_local <-+- br_fdb_changeaddr ✓
> >                 |                  +- br_fdb_change_mac_address ✓
> >                 |                  +- br_fdb_add_local ✓
> >                 +- br_fdb_cleanup ✓
> >                 +- br_fdb_flush ✓
> >                 +- br_fdb_delete_by_port ✓
> >                 +- fdb_delete_by_addr_and_port <--- __br_fdb_delete ✓
> >                 +- br_fdb_external_learn_del ✓
> >  - fdb_create <-+- fdb_add_local <-+- br_fdb_changeaddr ✓
> >                 |                  +- br_fdb_change_mac_address ✓
> >                 |                  +- br_fdb_add_local ✓
> >                 +- br_fdb_update ✓
> >                 +- fdb_add_entry <--- __br_fdb_add ✓
> >                 +- br_fdb_external_learn_add ✓
> > 
> > Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
> > ---
> >  include/uapi/linux/if_link.h | 1 +
> >  net/bridge/br_device.c       | 2 ++
> >  net/bridge/br_fdb.c          | 6 ++++++
> >  net/bridge/br_netlink.c      | 9 ++++++++-
> >  net/bridge/br_private.h      | 2 ++
> >  5 files changed, 19 insertions(+), 1 deletion(-)
> > 
> 
> I completely missed the fact that you don't deal with the situation where you already have fdbs created
> and a limit is set later, then it would be useless because it will start counting from 0 even though
> there are already entries.

This should not be an issue. The accounting starts with the bridge
creation and is never suspended, so if the user sets a limit later we
do not restart counting at 0.

The only corner case I can see there is if the user sets a new limit
lower than the current number of FDB entries. In that case the code
currently leaves the bridge in a state where the limit is violated,
but refuses new FDB entries until the total is back below the limit. The
alternative of cleaning out old FDB entries until their number is under
the limit again seems to be more error prone to me as well, so I'd rather
leave it that way.

> Also another issue that came to mind is that you don't deal with fdb_create()
> for "special" entries, i.e. when adding a port. Currently it will print an error, but you should revisit
> all callers and see where it might be a problem.

I'll have a look again, also to see whether only counting dynamic
entries created as a reaction to observed packets might be a viable
alternative. If the user creates the entries by adding a port or manually
via netlink I see no reason to restrict them to the same limit.

