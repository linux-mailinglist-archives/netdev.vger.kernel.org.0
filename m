Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5697E471EA4
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 00:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhLLXL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 18:11:59 -0500
Received: from mx4.wp.pl ([212.77.101.12]:41284 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230260AbhLLXL6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 18:11:58 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2021 18:11:58 EST
Received: (wp-smtpd smtp.wp.pl 31525 invoked from network); 13 Dec 2021 00:05:16 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1639350316; bh=IuenmZmLjJO5EeZREf7j9hjrsyHQE/JgXkTClLDzILk=;
          h=From:Subject:To:Cc;
          b=ElSc8llOJ9X+eurk7EZOMhdzH/2/aCnfrOWCQ9B9rCDJEgiayBOFtgKyd0CDcYZob
           KkKuBcony5roqSYeukukoVmbc+Eo2A7SaFO1DfpmLCvoobrJ8/nQFzsp8iNB/7NVev
           TVMgyH1jszxX28IZY7Wwvt+XItkdspMsDZxU/19I=
Received: from riviera.nat.ds.pw.edu.pl (HELO [192.168.3.133]) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <linux-kernel@vger.kernel.org>; 13 Dec 2021 00:05:16 +0100
From:   Aleksander Bajkowski <olek2@wp.pl>
Subject: Re: [PATCH net v2] net: lantiq_xrx200: increase buffer reservation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     hauke@hauke-m.de, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211206223909.749043-1-olek2@wp.pl>
 <20211207205448.3b297e7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <c4d93a2e-b4de-9b19-ff44-a122dbbb22b8@wp.pl>
Date:   Mon, 13 Dec 2021 00:05:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211207205448.3b297e7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-WP-MailID: e4c1644b2bfb5ce56930ccca2c1ddd69
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000B [McN0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Sorry for the late reply, but recently I haven't had access to
hardware to test different MTU values and packet lengths on the
hardware.

On 12/8/21 5:54 AM, Jakub Kicinski wrote:
> On Mon,  6 Dec 2021 23:39:09 +0100 Aleksander Jan Bajkowski wrote:
>> +static int xrx200_max_frame_len(int mtu)
>> +{
>> +	return VLAN_ETH_HLEN + mtu + ETH_FCS_LEN;
> 
> You sure the problem is not that this doesn't include ETH_HLEN? 
> MTU is the length of the L2 _payload_.
> 

VLAN_ETH_HLEN (14 + 4) contains ETH_HLEN (14). This function returns
the length of the frame that is written to the RX descriptor. Maybe
I don't understand the question and you are asking something else? 

>> +}
>> +
>> +static int xrx200_buffer_size(int mtu)
>> +{
>> +	return round_up(xrx200_max_frame_len(mtu) - 1, 4 * XRX200_DMA_BURST_LEN);
> 
> Why the - 1 ? 🤔
> 

This is how the hardware behaves. I don't really know where the -1
comes from. Unfortunately, I do not have access to TRM. 

> For a frame size 101 => max_frame_len 109 you'll presumably want 
> the buffer to be 116, not 108?
> 


For a frame size 101 => max_frame_len is 123 (18 + 101 + 4). Infact, PMAC strips FCS and ETH_FCS_LEN may not be needed. This behavior
is controlled by the PMAC_HD_CTL_RC bit. This bit is enabled from
the beginning of this driver. Ethtool has the option to enable
FCS reception, but the ethtool interface is not yet supported
by this driver. 

>> +}
>> +

Experiments show that the hardware starts to split the frame at
max_frame_len() - 1. Some examples:

pkt len		MTU	max_frame_size()	buffer_size()	desc1	desc2	desc3	desc4
----------------------------------------------------------------------------------------------
1506		1483		1505		1504		1502	4	X	X
1505		1483		1505		1504		1502	3	X	X
1504		1483		1505		1504		1504	X	X	X
1503		1483		1505		1504		1503	X	X	X
1502		1483		1505		1504		1502	X	X	X
1501		1483		1505		1504		1501	X	X	X
----------------------------------------------------------------------------------------------
1249		380		402		416		414	416	416	3
1248		380		402		416		414	416	416	2
1247		380		402		416		414	416	416	1
1246		380		402		416		414	416	416	X
1245		380		402		416		414	416	415	X
----------------------------------------------------------------------------------------------


In fact, this patch is a preparation for SG DMA support, which
I wrote some time ago.



