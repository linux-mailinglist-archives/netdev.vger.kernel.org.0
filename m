Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8B1767FF
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgCBXRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:17:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCBXRH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 18:17:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19CAC21D56;
        Mon,  2 Mar 2020 23:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583191026;
        bh=lJbi2zOTHVVJtrPD2NfzB8RlWBQwXjCRD7IvM3KyYsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tvirXxLBNI9+DF7jBkv9Qhdb01wspeMtjRowRscpirBMu9iiYEo69mJIQm2RDY03b
         fqpGIteydtlA7gtEk9mwddI1pnRLXfOKh6U3ovvc3l80+OJRIuVyuh7KR5LOGigPBy
         yzr9KFfKDOCczmblURBUqRfsCIdcUcOFrVa8oBOE=
Date:   Mon, 2 Mar 2020 15:17:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>, Thomas Graf <tgraf@suug.ch>
Subject: Re: ip link vf info truncating with many VFs
Message-ID: <20200302151704.56fe3dd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <16b289f6-b025-5dd3-443d-92d4c167e79c@intel.com>
References: <16b289f6-b025-5dd3-443d-92d4c167e79c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Feb 2020 16:33:40 -0800 Jacob Keller wrote:
> Hi,
> 
> I recently noticed an issue in the rtnetlink API for obtaining VF
> information.
> 
> If a device creates 222 or more VF devices, the rtnl_fill_vf function
> will incorrectly label the size of the IFLA_VFINFO_LIST attribute. This
> occurs because rtnl_fill_vfinfo will have added more than 65k (maximum
> size of a single attribute since nla_len is a __u16).
> 
> This causes the calculation in nla_nest_end to overflow and report a
> significantly shorter length value. Worse case, with 222 VFs, the "ip
> link show <device>" reports no VF info at all.
> 
> For some reason, the nla_put calls do not trigger an EMSGSIZE error,
> because the skb itself is capable of holding the data.
> 
> I think the right thing is probably to do some sort of
> overflow-protected calculation and print a warning... or find a way to
> fix nla_put to error with -EMSGSIZE if we would exceed the nested
> attribute size limit... I am not sure how to do that at a glance.

Making nla_nest_end() return an error on overflow seems like 
the most reasonable way forward to me, FWIW. Simply compare
the result to U16_MAX, I don't think anything more clever is
needed.

Some of the callers actually already check for errors of
nla_nest_end() (qdiscs' dump methods use the result which 
is later checked for less that zero).

Then rtnetlink code should be made aware that nla_nest_end() 
may fail.

(When you post it's probably a good idea to widen the CC list 
to Johannes Berg, Pablo, DaveA, Jiri..)
