Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE4426696B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbgIKUMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbgIKUMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 16:12:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 105522083E;
        Fri, 11 Sep 2020 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599855160;
        bh=vGe2G2na3mlIaJ/wyhHN9lIzKTpPTnK8kDqhJLkWqhw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=u7XNvLgJfLm+5X9IdVYOQHwvLVAY6B35CnyFVFis0bVowZ0PFvyWek22y3L2RBy3D
         05jf7HyioYqLlGyPZmsgM8iTA45leFaS4snam7iq5cu+y+01JxiDN2GZ6CB8ON1NhK
         o+CeCYZ7DxWIgq+nG09rF/PmVXR1LeP6UQ8j47AE=
Date:   Fri, 11 Sep 2020 13:12:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH net-next v1 00/11] make drivers/net/ethernet W=1
 clean
Message-ID: <20200911131238.1069129c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200911120005.00000178@intel.com>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
        <20200911075515.6d81066b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200911120005.00000178@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 12:00:05 -0700 Jesse Brandeburg wrote:
> > I feel slightly bad for saying this but I think your config did not
> > include all the drivers, 'cause I'm still getting some warnings after
> > patch 11. Regardless this is impressive effort, thanks!  
> 
> No worries! I want to get it right, can you share your methodology?
> 
> I saw from some other message that you're doing
> make CC="ccache gcc" allmodconfig
> make CC="ccache gcc" -j 64 W=1 C=1
> 
> Is that the right sequence?

Yes, that's it.

> did you start with a make mrproper as well?

Nope, the machine is barely keeping up as is ;)

> I may have missed some drivers when I did this:
> make allyesconfig
> make menuconfig
> <turn on all "Ethernet Drivers" = m manually>

Yeah, maybe you need COMPILE_TEST? (full list of the warnings triggered
by the last patch at the end of the email)

> but I'd like to target the actual job you're running and use that as
> the short-term goal.

If the code is of any use:

https://github.com/kuba-moo/nipa

But it expects to run against a patchwork instance.

> Also, if you have any comments about the removal of the lvalue from
> some of the register read operations, I figure that is the riskiest
> part of all this.

Nothing looked suspicious to me. Besides if the compiler is warning that
the variable is unused I'm pretty sure it will optimize that variable
out, anyway so machine code shouldn't change with this series.


../drivers/net/ethernet/atheros/atlx/atl1.c:1999:26: warning: cast to restricted __le16
../drivers/net/ethernet/atheros/atlx/atl1.c:2060:33: warning: cast to restricted __le16
../drivers/net/ethernet/atheros/atlx/atl1.c:2125:45: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2125:45:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2125:45:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2127:45: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2127:45:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2127:45:    right side has type unsigned int
../drivers/net/ethernet/atheros/atlx/atl1.c:2130:45: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2130:45:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2130:45:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2131:45: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2131:45:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2131:45:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2141:45: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2141:45:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2141:45:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2145:37: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2145:37:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2145:37:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2147:37: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2147:37:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2147:37:    right side has type unsigned int
../drivers/net/ethernet/atheros/atlx/atl1.c:2149:37: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2149:37:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2149:37:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2151:37: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2151:37:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2151:37:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2173:29: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2173:29:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2173:29:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2175:29: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2175:29:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2175:29:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2177:29: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2177:29:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2177:29:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2206:23: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atlx/atl1.c:2303:28: warning: invalid assignment: &=
../drivers/net/ethernet/atheros/atlx/atl1.c:2303:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2303:28:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2304:32: warning: restricted __le16 degrades to integer
../drivers/net/ethernet/atheros/atlx/atl1.c:2304:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2304:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2304:28:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2311:27: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atlx/atl1.c:2315:44: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2315:44:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2315:44:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2317:44: warning: invalid assignment: &=
../drivers/net/ethernet/atheros/atlx/atl1.c:2317:44:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2317:44:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2321:36: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2321:36:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2321:36:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2401:29: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2401:29:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2401:29:    right side has type int
../drivers/net/ethernet/atheros/atlx/atl1.c:2402:29: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atlx/atl1.c:2402:29:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atlx/atl1.c:2402:29:    right side has type int
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1923:28: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1923:28:    expected unsigned short [assigned] [usertype] clscode
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1923:28:    got restricted __be16 [usertype]
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1924:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1924:25:    expected unsigned short [assigned] [usertype] rsvd
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1924:25:    got restricted __be16 [usertype]
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1926:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1926:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1926:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1926:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1926:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1926:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1937:29: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1937:29:    expected unsigned short [assigned] [usertype] clscode
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1937:29:    got restricted __be16 [usertype]
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1938:26: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1938:26:    expected unsigned short [assigned] [usertype] rsvd
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1938:26:    got restricted __be16 [usertype]
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1940:30: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1940:30: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1940:30: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1940:30: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1940:30: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1940:30: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1903:24: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1903:24:    expected unsigned int val
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:1903:24:    got restricted __le32 [usertype]
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2105:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2105:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2105:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2105:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2105:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2105:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2106:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2106:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2106:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2106:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2106:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2106:31: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2107:31: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2107:31: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2107:31: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2107:31: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2209:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2209:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2209:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2209:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2209:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2209:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2422:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2422:25:    expected unsigned int [usertype]
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:2422:25:    got restricted __be32 [usertype]
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3068:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3068:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3068:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3068:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3068:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3068:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3070:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3070:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3070:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3070:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3070:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3070:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3073:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3073:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3073:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3073:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3073:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3073:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3101:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3101:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3101:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3101:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3101:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3101:21: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3103:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3103:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3103:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3103:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3103:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3103:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3106:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3106:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3106:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3106:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3106:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3106:23: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3140:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3140:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3140:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3140:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3140:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3140:26: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3147:40: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3147:40: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3147:40: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3147:40: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3147:40: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3147:40: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3148:39: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3148:39: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3148:39: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3148:39: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3148:39: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3148:39: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3151:41: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3151:41: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3151:41: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3151:41: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3151:41: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.c:3151:41: warning: too many warnings
../drivers/net/ethernet/brocade/bna/bfa_cee.c:42:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:42:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:42:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:42:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:44:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:44:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:44:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:44:25: warning: cast to restricted __be16
../drivers/net/ethernet/brocade/bna/bfa_cee.c:34:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_cee.c:34:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_cee.c:34:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_cee.c:34:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_cee.c:34:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_cee.c:34:29: warning: cast to restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_cee.c: note: in included file (through ../drivers/net/ethernet/brocade/bna/bfa_cee.h):
../drivers/net/ethernet/brocade/bna/bfa_ioc.h:55:34: warning: cast from restricted __be32
../drivers/net/ethernet/brocade/bna/bfa_ioc.h:56:34: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:280:16: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cadence/macb_main.c:280:16:    expected unsigned int [usertype] bottom
../drivers/net/ethernet/cadence/macb_main.c:280:16:    got restricted __le32 [usertype]
../drivers/net/ethernet/cadence/macb_main.c:282:13: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cadence/macb_main.c:282:13:    expected unsigned short [usertype] top
../drivers/net/ethernet/cadence/macb_main.c:282:13:    got restricted __le16 [usertype]
../drivers/net/ethernet/cadence/macb_main.c:3087:39: warning: restricted __be32 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3092:39: warning: restricted __be32 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3097:40: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3097:69: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3119:20: warning: restricted __be32 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3123:20: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3123:20:    expected unsigned int [assigned] [usertype] w0
../drivers/net/ethernet/cadence/macb_main.c:3123:20:    got restricted __be32 [usertype] ip4src
../drivers/net/ethernet/cadence/macb_main.c:3133:20: warning: restricted __be32 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3137:20: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3137:20:    expected unsigned int [assigned] [usertype] w0
../drivers/net/ethernet/cadence/macb_main.c:3137:20:    got restricted __be32 [usertype] ip4dst
../drivers/net/ethernet/cadence/macb_main.c:3147:21: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3147:50: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3153:30: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3154:30: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3161:36: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3162:38: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3165:38: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    expected unsigned int [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    got restricted __be32 [usertype] ip4src
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    expected unsigned int [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    got restricted __be32 [usertype] ip4dst
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    expected unsigned short [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    got restricted __be16 [usertype] psrc
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    expected unsigned short [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3201:9:    got restricted __be16 [usertype] pdst
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3201:9: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    expected unsigned int [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    got restricted __be32 [usertype] ip4src
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    expected unsigned int [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    got restricted __be32 [usertype] ip4dst
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be32
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    expected unsigned short [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    got restricted __be16 [usertype] psrc
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    expected unsigned short [usertype] val
../drivers/net/ethernet/cadence/macb_main.c:3254:25:    got restricted __be16 [usertype] pdst
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be16
../drivers/net/ethernet/cadence/macb_main.c:3254:25: warning: cast from restricted __be16
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:441:38: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:441:38:    expected restricted __be32 [usertype] ip4src
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:441:38:    got unsigned int [usertype]
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:444:38: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:444:38:    expected restricted __be32 [usertype] ip4dst
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:444:38:    got unsigned int [usertype]
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:447:36: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:447:36:    expected restricted __be16 [usertype] psrc
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:447:36:    got unsigned short [usertype]
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:450:36: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:450:36:    expected restricted __be16 [usertype] pdst
../drivers/net/ethernet/cisco/enic/enic_ethtool.c:450:36:    got unsigned short [usertype]
../drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:521:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:521:30:    expected restricted __be16 [usertype] l2t_idx
../drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c:521:30:    got restricted __be32 [usertype]
../drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:279:11: warning: symbol 'dmae_reg_go_c' was not declared. Should it be static?
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1446:45: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1474:46: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1663:44: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1663:44:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1663:44:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1666:44: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1666:44:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1666:44:    right side has type unsigned int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1669:44: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1669:44:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1669:44:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1671:44: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1671:44:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1671:44:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1688:36: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1688:36:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1688:36:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1690:36: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1690:36:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1690:36:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1692:36: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1692:36:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1692:36:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1715:23: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1732:42: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1733:27: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1732:32: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1732:32:    expected restricted __le32 [usertype] word2
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1732:32:    got unsigned int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1777:42: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1778:27: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1777:32: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1777:32:    expected restricted __le32 [usertype] word2
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1777:32:    got unsigned int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1827:50: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1828:43: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1827:40: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1827:40:    expected restricted __le32 [usertype] word2
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1827:40:    got unsigned int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1833:17: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1835:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1835:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1835:28:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1838:24: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1838:24:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1838:24:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1887:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1887:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1887:28:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1889:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1889:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1889:28:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1894:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1894:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1894:28:    right side has type int
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1897:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1897:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1e/atl1e_main.c:1897:28:    right side has type int
../drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:681:67: warning: incorrect type in argument 3 (different base types)
../drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:681:67:    expected restricted __le32 [usertype] data
../drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:681:67:    got int
../drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:898:31: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:898:31:    expected unsigned int [usertype]
../drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:898:31:    got restricted __be32 [usertype]
../drivers/net/ethernet/chelsio/cxgb3/t3_hw.c:3666:52: warning: dubious: !x | y
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1804:21: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1805:39: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1818:24: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1827:26: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1827:26: warning: cast to restricted __le16
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1831:41: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1848:24: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1851:25: warning: restricted __le16 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1851:25: warning: restricted __le16 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1852:32: warning: cast to restricted __le16
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1761:28: warning: invalid assignment: &=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1761:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1761:28:    right side has type unsigned int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:1774:25: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2007:47: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2007:47:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2007:47:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2029:37: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2029:37:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2029:37:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2030:37: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2030:37:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2030:37:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2032:39: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2032:39:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2032:39:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2035:31: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2035:31:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2035:31:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2036:31: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2036:31:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2036:31:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2038:31: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2038:31:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2038:31:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2056:39: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2056:39:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2056:39:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2058:39: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2058:39:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2058:39:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2060:39: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2060:39:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2060:39:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2103:19: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2172:24: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2172:24:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2172:24:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2228:22: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2228:22:    expected unsigned short [usertype] vlan
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2228:22:    got restricted __le16 [usertype]
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2229:17: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2229:17:    expected restricted __le16 [usertype] tag
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2229:17:    got int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2230:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2230:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2230:28:    right side has type int
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2235:28: warning: invalid assignment: |=
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2235:28:    left side has type restricted __le32
../drivers/net/ethernet/atheros/atl1c/atl1c_main.c:2235:28:    right side has type int
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2373:50: warning: incorrect type in argument 1 (different base types)
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2373:50:    expected unsigned int [usertype] rss
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2373:50:    got restricted __be32 [assigned] [usertype] rss_hi
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2436:43: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2436:43:    expected restricted __wsum [usertype] csum
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2436:43:    got restricted __be32 [assigned] [usertype] rss_hi
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2437:47: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2437:47:    expected unsigned int [usertype] priority
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2437:47:    got restricted __be32 [assigned] [usertype] rss_lo
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2118:16: warning: cast to restricted __be32
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2118:16: warning: cast to restricted __be32
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2118:16: warning: cast to restricted __be32
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2118:16: warning: cast to restricted __be32
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2118:16: warning: cast to restricted __be32
../drivers/net/ethernet/chelsio/cxgb3/sge.c:2118:16: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_main.c:831:25: warning: cast to restricted __be16
../drivers/net/ethernet/huawei/hinic/hinic_main.c:831:25: warning: cast to restricted __be16
../drivers/net/ethernet/huawei/hinic/hinic_main.c:831:25: warning: cast to restricted __be16
../drivers/net/ethernet/huawei/hinic/hinic_main.c:831:25: warning: cast to restricted __be16
../drivers/net/ethernet/micrel/ksz884x.c:3519:50: warning: restricted pci_power_t degrades to integer
../drivers/net/ethernet/micrel/ksz884x.c:3840:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:3840:37:    expected unsigned int [usertype] next
../drivers/net/ethernet/micrel/ksz884x.c:3840:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:3842:29: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:3842:29:    expected unsigned int [usertype] next
../drivers/net/ethernet/micrel/ksz884x.c:3842:29:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:3844:33: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:3844:33:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:3844:33:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:4750:31: warning: cast to restricted __le32
../drivers/net/ethernet/micrel/ksz884x.c:5043:31: warning: cast to restricted __le32
../drivers/net/ethernet/micrel/ksz884x.c:5079:31: warning: cast to restricted __le32
../drivers/net/ethernet/micrel/ksz884x.c:5124:31: warning: cast to restricted __le32
../drivers/net/ethernet/micrel/ksz884x.c:1603:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1605:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1619:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1619:25:    expected unsigned int [usertype] addr
../drivers/net/ethernet/micrel/ksz884x.c:1619:25:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1603:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1605:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1639:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1639:25:    expected unsigned int [usertype] addr
../drivers/net/ethernet/micrel/ksz884x.c:1639:25:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1639:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1639:25:    expected unsigned int [usertype] addr
../drivers/net/ethernet/micrel/ksz884x.c:1639:25:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1603:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1605:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1603:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1605:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1639:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1639:25:    expected unsigned int [usertype] addr
../drivers/net/ethernet/micrel/ksz884x.c:1639:25:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1595:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1595:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1595:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:4966:18: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:4966:18:    expected unsigned short protocol
../drivers/net/ethernet/micrel/ksz884x.c:4966:18:    got restricted __be16 [usertype] protocol
../drivers/net/ethernet/micrel/ksz884x.c:4969:25: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/micrel/ksz884x.c:4970:26: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:4970:26:    expected unsigned short protocol
../drivers/net/ethernet/micrel/ksz884x.c:4970:26:    got restricted __be16 [usertype] tot_len
../drivers/net/ethernet/micrel/ksz884x.c:4974:25: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/micrel/ksz884x.c:1603:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1605:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:4966:18: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:4966:18:    expected unsigned short protocol
../drivers/net/ethernet/micrel/ksz884x.c:4966:18:    got restricted __be16 [usertype] protocol
../drivers/net/ethernet/micrel/ksz884x.c:4969:25: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/micrel/ksz884x.c:4970:26: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:4970:26:    expected unsigned short protocol
../drivers/net/ethernet/micrel/ksz884x.c:4970:26:    got restricted __be16 [usertype] tot_len
../drivers/net/ethernet/micrel/ksz884x.c:4974:25: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/micrel/ksz884x.c:1603:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1605:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:4966:18: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:4966:18:    expected unsigned short protocol
../drivers/net/ethernet/micrel/ksz884x.c:4966:18:    got restricted __be16 [usertype] protocol
../drivers/net/ethernet/micrel/ksz884x.c:4969:25: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/micrel/ksz884x.c:4970:26: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:4970:26:    expected unsigned short protocol
../drivers/net/ethernet/micrel/ksz884x.c:4970:26:    got restricted __be16 [usertype] tot_len
../drivers/net/ethernet/micrel/ksz884x.c:4974:25: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/micrel/ksz884x.c:1603:37: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1603:37:    got restricted __le32 [usertype]
../drivers/net/ethernet/micrel/ksz884x.c:1605:30: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    expected unsigned int [usertype] data
../drivers/net/ethernet/micrel/ksz884x.c:1605:30:    got restricted __le32 [usertype]
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:333:17: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:333:17:    expected unsigned int [addressable] [usertype] db_info
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:333:17:    got restricted __be32 [usertype]
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:413:23: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:413:23:    expected unsigned long long [usertype]
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:413:23:    got restricted __be64 [usertype]
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:536:27: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:536:27: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:536:27: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:536:27: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:536:27: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:536:27: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:577:21: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:577:21: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:577:21: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:577:21: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:577:21: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:577:21: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:625:14: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:625:14: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:625:14: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:625:14: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:625:14: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:625:14: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:630:19: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:630:19: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:630:19: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:630:19: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:630:19: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:630:19: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:661:30: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:661:30: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:661:30: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:661:30: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:661:30: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:661:30: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c:707:31: warning: cast to restricted __be64
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:324:24: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:324:24: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:324:24: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:324:24: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:324:24: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:324:24: warning: cast to restricted __be32
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:617:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:617:25:    expected unsigned int [usertype]
../drivers/net/ethernet/huawei/hinic/hinic_hw_eqs.c:617:25:    got restricted __be32 [usertype]
../drivers/net/ethernet/natsemi/ns83820.c:900:39: warning: cast to restricted __be16
../drivers/net/ethernet/natsemi/ns83820.c:900:39: warning: cast to restricted __be16
../drivers/net/ethernet/natsemi/ns83820.c:900:39: warning: cast to restricted __be16
../drivers/net/ethernet/natsemi/ns83820.c:900:39: warning: cast to restricted __be16
../drivers/net/ethernet/natsemi/ns83820.c:1119:42: warning: restricted __be16 degrades to integer
../drivers/net/ethernet/natsemi/ns83820.c:1982:29: warning: cast to restricted __le32
../drivers/net/ethernet/neterion/s2io.c:6951:41: warning: cast to restricted __be32
../drivers/net/ethernet/neterion/s2io.c:6951:41: warning: cast to restricted __be32
../drivers/net/ethernet/neterion/s2io.c:6951:41: warning: cast to restricted __be32
../drivers/net/ethernet/neterion/s2io.c:6951:41: warning: cast to restricted __be32
../drivers/net/ethernet/neterion/s2io.c:6951:41: warning: cast to restricted __be32
../drivers/net/ethernet/neterion/s2io.c:6951:41: warning: cast to restricted __be32
../drivers/net/ethernet/neterion/s2io.c: note: in included file:
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (f00000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (ffbbffbbffbbffbb becomes ffbbffbb)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (ffbbffbbffbbffbb becomes ffbbffbb)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (7f00000001 becomes 1)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (102030405060000 becomes 5060000)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (feffffffffff0000 becomes ffff0000)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (4c0d000000000000 becomes 0)
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:890:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:891:37: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:903:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:904:35: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:918:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:919:46: warning: cast to restricted __be64
../drivers/net/ethernet/neterion/vxge/vxge-config.c:157:1: warning: context imbalance in 'vxge_hw_vpath_fw_api' - different lock contexts for basic block
../drivers/net/ethernet/neterion/vxge/vxge-traffic.c: note: in included file:
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (1000000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (100000000000000 becomes 0)
../drivers/net/ethernet/neterion/vxge/vxge-config.c: note: in included file:
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (8000000000000000 becomes 0)
../include/linux/io-64-nonatomic-lo-hi.h:21:16: warning: cast truncates bits from constant value (100000000000000 becomes 0)
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1248:37: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/packetengines/yellowfin.c:1253:49: warning: cast from restricted __le32
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:2135:41: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:2135:41:    expected void *reg
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:2135:41:    got unsigned int [noderef] __iomem *
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:33: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:33:    expected unsigned short [usertype] uid_hi
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:33:    got restricted __be16 [usertype]
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:45: warning: incorrect type in argument 3 (different base types)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:45:    expected unsigned int [usertype] uid_lo
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:45:    got restricted __be32 [usertype]
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:56: warning: incorrect type in argument 4 (different base types)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:56:    expected unsigned short [usertype] seqid
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:157:56:    got restricted __be16 [usertype]
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:306:26: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:306:26:    expected void const [noderef] __iomem *
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:306:26:    got void *reg
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:336:33: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:336:33:    expected void *reg
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:336:33:    got unsigned int [noderef] __iomem *
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:343:33: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:343:33:    expected void *reg
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:343:33:    got unsigned int [noderef] __iomem *
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:356:33: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:356:33:    expected void *reg
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:356:33:    got unsigned int [noderef] __iomem *
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:397:33: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:397:33:    expected void *reg
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:397:33:    got unsigned int [noderef] __iomem *
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:466:41: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:466:41:    expected void *reg
../drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:466:41:    got unsigned int [noderef] __iomem *
../drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c:1035:24: warning: cast to restricted __le64
../drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c:1037:24: warning: cast to restricted __le64
../drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c:2133:17: warning: cast truncates bits from constant value (42110030 becomes 30)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_hw.c:2133:17: warning: cast truncates bits from constant value (42110030 becomes 30)
../drivers/net/ethernet/neterion/vxge/vxge-main.c:116:27: warning: context imbalance in 'vxge_poll_inta' - different lock contexts for basic block
../drivers/net/ethernet/neterion/vxge/vxge-main.c:116:27: warning: context imbalance in 'vxge_netpoll' - different lock contexts for basic block
../drivers/net/ethernet/neterion/vxge/vxge-main.c:116:27: warning: context imbalance in 'vxge_tx_msix_handle' - different lock contexts for basic block
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:573:25: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:576:38: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:575:31: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:575:62: warning: incorrect type in initializer (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:575:62:    expected restricted __le32 [usertype] offs
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:575:62:    got unsigned int
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:577:35: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:579:21: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:580:66: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:603:54: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:603:64: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:603:20: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:617:22: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:629:63: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:629:26: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:628:20: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:635:18: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:635:55: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:634:16: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:638:21: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:638:50: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:652:22: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:664:63: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:664:26: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:663:20: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:670:18: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:670:55: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:669:16: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:672:21: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:672:50: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:699:55: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:699:65: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:699:20: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:705:25: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:712:38: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:711:24: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:711:22: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:711:22:    expected restricted __le32 [usertype] offs
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:711:22:    got unsigned int
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:713:25: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:714:32: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:719:33: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:720:62: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:768:19: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:768:19: warning: incorrect type in initializer (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:768:19:    expected int idx
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:768:19:    got restricted __le32 [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:779:26: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:778:16: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:778:14: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:778:14:    expected restricted __le32 [usertype] offs
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:778:14:    got unsigned int
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:781:48: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:790:22: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:790:22:    expected unsigned int [usertype] offs
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:790:22:    got restricted __le32 [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:803:22: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:803:22:    expected unsigned int [usertype] offs
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:803:22:    got restricted __le32 [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:835:38: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:836:33: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:849:33: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:849:24: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:849:48: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:849:45: warning: incorrect type in return expression (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:849:45:    expected restricted __le32
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:849:45:    got unsigned int
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:862:28: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:864:25: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:864:45: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:865:58: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:864:70: warning: incorrect type in return expression (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:864:70:    expected restricted __le32
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:864:70:    got unsigned int
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:913:21: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:913:21:    expected unsigned int [usertype] val
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:913:21:    got restricted __le32
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1001:72: warning: incorrect type in argument 3 (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1001:72:    expected unsigned long long [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1001:72:    got restricted __le64 [assigned] [usertype] data
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1016:60: warning: incorrect type in argument 3 (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1016:60:    expected unsigned long long [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1016:60:    got restricted __le64 [assigned] [usertype] data
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1027:60: warning: incorrect type in argument 3 (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1027:60:    expected unsigned long long [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1027:60:    got restricted __le64 [assigned] [usertype] data
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1101:23: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1101:23: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1101:23: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1125:24: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1125:24: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1125:24: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1125:22: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1125:22:    expected restricted __le32 [addressable] [usertype] flash_fw_ver
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1125:22:    got unsigned int
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1129:46: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c:1141:21: warning: restricted __le32 degrades to integer
../drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c:894:25: warning: incorrect type in assignment (different base types)
../drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c:894:25:    expected unsigned int [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_ethtool.c:894:25:    got restricted __le32 [usertype]
../drivers/net/ethernet/qlogic/netxen/netxen_nic_ctx.c:201:31: warning: cast to restricted __le32
../drivers/net/ethernet/sun/cassini.c:236:9: warning: context imbalance in 'cas_shutdown' - different lock contexts for basic block
../drivers/net/ethernet/sun/cassini.c:236:9: warning: context imbalance in 'cas_reset_task' - different lock contexts for basic block
../drivers/net/ethernet/via/via-rhine.c:1149:39: warning: cast removes address space '__iomem' of expression
../drivers/net/ethernet/sun/cassini.c:236:9: warning: context imbalance in 'cas_link_timer' - different lock contexts for basic block
../drivers/net/ethernet/sun/cassini.c:236:9: warning: context imbalance in 'cas_open' - different lock contexts for basic block
../drivers/net/ethernet/sun/cassini.c:236:9: warning: context imbalance in 'cas_close' - different lock contexts for basic block
../drivers/net/ethernet/sun/cassini.c:236:9: warning: context imbalance in 'cas_suspend' - different lock contexts for basic block
../drivers/net/ethernet/sun/cassini.c:236:9: warning: context imbalance in 'cas_resume' - different lock contexts for basic block
../drivers/net/ethernet/via/via-velocity.c: note: in included file:
../drivers/net/ethernet/via/via-velocity.h:237:24: warning: mixed bitwiseness
../drivers/net/ethernet/via/via-velocity.c:88:26: warning: incorrect type in initializer (different address spaces)
../drivers/net/ethernet/via/via-velocity.c:88:26:    expected void *addr
../drivers/net/ethernet/via/via-velocity.c:88:26:    got struct mac_regs [noderef] __iomem *mac_regs
../drivers/net/ethernet/via/via-velocity.c:91:49: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:91:49:    expected restricted pci_power_t [usertype] state
../drivers/net/ethernet/via/via-velocity.c:91:49:    got char state
../drivers/net/ethernet/via/via-velocity.c:93:36: warning: incorrect type in argument 2 (different address spaces)
../drivers/net/ethernet/via/via-velocity.c:93:36:    expected void volatile [noderef] __iomem *addr
../drivers/net/ethernet/via/via-velocity.c:93:36:    got void *
../drivers/net/ethernet/via/via-velocity.c:1745:34: warning: cast from restricted __le16
../drivers/net/ethernet/via/via-velocity.c:1745:34: warning: cast from restricted __le16
../drivers/net/ethernet/via/via-velocity.c:1745:34: warning: cast from restricted __le16
../drivers/net/ethernet/via/via-velocity.c:1745:34: warning: cast from restricted __le16
../drivers/net/ethernet/via/via-velocity.c:1745:34: warning: cast from restricted __le16
../drivers/net/ethernet/via/via-velocity.c:1745:34: warning: cast from restricted __le16
../drivers/net/ethernet/via/via-velocity.c:1748:17: warning: cast to restricted __le16
../drivers/net/ethernet/via/via-velocity.c:2241:40: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:2241:40:    expected char state
../drivers/net/ethernet/via/via-velocity.c:2241:40:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:2249:48: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:2249:48:    expected char state
../drivers/net/ethernet/via/via-velocity.c:2249:48:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:2436:48: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:2436:48:    expected char state
../drivers/net/ethernet/via/via-velocity.c:2436:48:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:2449:48: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:2449:48:    expected char state
../drivers/net/ethernet/via/via-velocity.c:2449:48:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:2874:40: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:2874:40:    expected char state
../drivers/net/ethernet/via/via-velocity.c:2874:40:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:3149:48: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:3149:48:    expected char state
../drivers/net/ethernet/via/via-velocity.c:3149:48:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:3155:48: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:3155:48:    expected char state
../drivers/net/ethernet/via/via-velocity.c:3155:48:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:3207:40: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:3207:40:    expected char state
../drivers/net/ethernet/via/via-velocity.c:3207:40:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:3277:48: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:3277:48:    expected char state
../drivers/net/ethernet/via/via-velocity.c:3277:48:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/via/via-velocity.c:3294:48: warning: incorrect type in argument 2 (different base types)
../drivers/net/ethernet/via/via-velocity.c:3294:48:    expected char state
../drivers/net/ethernet/via/via-velocity.c:3294:48:    got restricted pci_power_t [usertype]
../drivers/net/ethernet/ethoc.c:317:13: warning: incorrect type in assignment (different address spaces)
../drivers/net/ethernet/ethoc.c:317:13:    expected void *vma
../drivers/net/ethernet/ethoc.c:317:13:    got void [noderef] __iomem *membase
../drivers/net/ethernet/ethoc.c:454:67: warning: incorrect type in argument 2 (different address spaces)
../drivers/net/ethernet/ethoc.c:454:67:    expected void const volatile [noderef] __iomem *
../drivers/net/ethernet/ethoc.c:454:67:    got void *src
../drivers/net/ethernet/ethoc.c:912:21: warning: incorrect type in argument 1 (different address spaces)
../drivers/net/ethernet/ethoc.c:912:21:    expected void volatile [noderef] __iomem *
../drivers/net/ethernet/ethoc.c:912:21:    got void *[assigned] dest
../drivers/net/ethernet/ethoc.c:1112:31: warning: incorrect type in assignment (different address spaces)
../drivers/net/ethernet/ethoc.c:1112:31:    expected void [noderef] __iomem *membase
../drivers/net/ethernet/ethoc.c:1112:31:    got void *
