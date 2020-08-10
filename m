Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8D8240CD6
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 20:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728112AbgHJSRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 14:17:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:55750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgHJSRa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 14:17:30 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E48CC207FF;
        Mon, 10 Aug 2020 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597083449;
        bh=lhOfgn563/hfQV5pl6qTvLhjlAalh82/pFW+g7YHZAM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QzqKh69tdGzyy6wbQqdcbQzZMcFleuyePwYWtna0RSI6+RzFgFSxN0KZ/p81M9uUL
         9qAld9F1gS3qa5W7mMVlSIIDUv4GLuIrKg4xxlIbs8P7k6miG4uTMU/QVhsRefABkO
         VQK+lcO5NAdDibQbw7FS6ueiBRcoJ+pIU4USdqGI=
Date:   Mon, 10 Aug 2020 11:17:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200810111727.6f55943d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4c25811f-e571-e39d-f25c-59b821264b3f@intel.com>
References: <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
        <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
        <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
        <20200803141442.GB2290@nanopsycho>
        <20200803135703.16967635@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200804100418.GA2210@nanopsycho>
        <20200804133946.7246514e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200805110258.GA2169@nanopsycho>
        <20200806112530.0588b3ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8b06ade2-dfbe-8894-0d6a-afe9c2f41b4e@mellanox.com>
        <20200810095305.0b9661ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4c25811f-e571-e39d-f25c-59b821264b3f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Aug 2020 10:09:20 -0700 Jacob Keller wrote:
> >> But I am still missing something: fw-activate implies that it will 
> >> activate a new FW image stored on flash, pending activation. What if the 
> >> user wants to reset and reload the FW if no new FW pending ? Should we 
> >> add --force option to fw-activate level ?  
> > 
> > Since reload does not check today if anything changed - i.e. if reload
> > is actually needed, neither should fw-activate, IMO. I'd expect the
> > "--force behavior" to be the default.
> >   
> 
> Yep. What about if there is HW/FW that can't initiate the fw-activate
> reset unless there is a pending update? I think ice firmware might
> respond to the "please reset/activate" command with a specific status
> code indicating that no update was pending.
> 
> I think the simplest solution is to just interpret this as a success.
> Alternatively we could report a specific error to inform user that no
> activation took place?

I'd do EOPNOTSUPP + extack.
