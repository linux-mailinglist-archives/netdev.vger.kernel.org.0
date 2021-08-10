Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1C73E8325
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 20:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231504AbhHJSpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 14:45:41 -0400
Received: from carlson.workingcode.com ([50.78.21.49]:36564 "EHLO
        carlson.workingcode.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbhHJSph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 14:45:37 -0400
X-Greylist: delayed 2018 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 14:45:36 EDT
Received: from dhcp-230.workingcode.com (dhcp-230.workingcode.com [192.168.254.230])
        (authenticated bits=0)
        by carlson.workingcode.com (8.16.1/8.16.1/SUSE Linux 0.8) with ESMTPSA id 17AIBBBD028986
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Tue, 10 Aug 2021 14:11:11 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 carlson.workingcode.com 17AIBBBD028986
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=workingcode.com;
        s=carlson; t=1628619072;
        bh=Dc/ivB0jqRtSrppLt2glb6c/XTb4v+nAv6EiAgRwZ6s=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ZZ4VgC0A+3WruNRcjKqN0+Nq/76VKRCI0IcZyxMGxXY73RqPL8FyEsHVhov5k11S+
         gsTbH97XAUv1mFUOTR7EW8z+DrjQYRl0dmsn9+c1RNX9e9mhD3my01Dl0xbR0qmfni
         5iNDW7ZGW2GmruYBjw//7QNciNup8EHOkAvcNeTA=
Subject: Re: [PATCH] ppp: Add rtnl attribute IFLA_PPP_UNIT_ID for specifying
 ppp unit id
To:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Chris Fowler <cfowler@outpostsentinel.com>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210807163749.18316-1-pali@kernel.org>
 <20210809122546.758e41de@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210809193109.mw6ritfdu27uhie7@pali> <20210810153941.GB14279@pc-32.home>
 <BN0P223MB0327A247724B7AE211D2E84EA7F79@BN0P223MB0327.NAMP223.PROD.OUTLOOK.COM>
 <20210810171626.z6bgvizx4eaafrbb@pali>
From:   James Carlson <carlsonj@workingcode.com>
Message-ID: <2f10b64e-ba50-d8a5-c40a-9b9bd4264155@workingcode.com>
Date:   Tue, 10 Aug 2021 14:11:11 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810171626.z6bgvizx4eaafrbb@pali>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-DCC-MGTINTERNET-Metrics: carlson 1170; Body=9 Fuz1=9 Fuz2=9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/10/21 1:16 PM, Pali Rohár wrote:
> On Tuesday 10 August 2021 16:38:32 Chris Fowler wrote:
>> Isn't the UNIT ID the interface number?  As in 'unit 100' will give me ppp100?
> 
> If you do not specify pppd 'ifname' argument then pppd argument 'unit 100'
> will cause that interface name would be ppp100.
> 
> But you are free to rename interface to any string which you like, even
> to "ppp99".
> 
> But this ppp unit id is not interface number. Interface number is
> another number which has nothing with ppp unit id and is assigned to
> every network interface (even loopback). You can see them as the first
> number in 'ip -o l' output. Or you can retrieve it via if_nametoindex()
> function in C.

Correct; completely unrelated to the notion of "interface index."

> ... So if people are really using pppd's 'unit' argument then I think it
> really make sense to support it also in new rtnl interface.

The pppd source base is old.  It dates to the mid-80's.  So it predates 
not just rename-able interfaces in Linux but Linux itself.

I recall supported platforms in the past (BSD-derived) that didn't 
support allowing the user to specify the unit number.  In general, on 
those platforms, the option was accepted and just ignored, and there 
were either release notes or man page updates (on that platform) that 
indicated that "unit N" wouldn't work there.

Are there users on Linux who make use of the "unit" option and who would 
mourn its loss?  Nobody really knows.  It's an ancient feature that was 
originally intended to deal with systems that couldn't rename interfaces 
(where one had to make sure that the actual interface selected matched 
up with pre-configured filtering rules or static routes or the like), 
and to make life nice for administrators (e.g., making sure that serial 
port 1 maps to ppp1, port 2 is ppp2, and so on).

I would think and hope most users reach for the more-flexible "ifname" 
option first, but I certainly can't guarantee it.  It could be buried in 
a script somewhere or (god forbid) some kind of GUI or "usability" tool.

If I were back at Sun, I'd probably call it suitable only for a "Major" 
release, as it removes a publicly documented feature.  But I don't know 
what the considerations are here.  Maybe it's just a "don't really care."

-- 
James Carlson         42.703N 71.076W         <carlsonj@workingcode.com>
