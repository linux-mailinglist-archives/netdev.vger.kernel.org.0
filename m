Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF00622BFA
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiKIM5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKIM5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:57:14 -0500
X-Greylist: delayed 394 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Nov 2022 04:57:13 PST
Received: from smtp71.iad3b.emailsrvr.com (smtp71.iad3b.emailsrvr.com [146.20.161.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC752175A9
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mev.co.uk;
        s=20190130-41we5z8j; t=1667998238;
        bh=erXAaK3z5v3q+xCQrvz4K5eCN+bQc7JXs4Sv8+zj9yA=;
        h=Date:To:From:Subject:From;
        b=QUsMhcojL3gAAP4fvC09yh/IcLOvNmWnkYYg0cehUSZoQLS72AeqSayBaLJefFB4D
         66xEZ/ch28O+YIgDVpFKlC6l9zPNBMCqdThBA0O6uvExcViTtagEUQlJE1x2PgVyQ/
         yaf1PQn66xAzDpNiiOT9Rqh9H5sp05uM0Cc8Xixs=
X-Auth-ID: abbotti@mev.co.uk
Received: by smtp1.relay.iad3b.emailsrvr.com (Authenticated sender: abbotti-AT-mev.co.uk) with ESMTPSA id 468B0600E8
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 07:50:38 -0500 (EST)
Message-ID: <c3755dfd-004a-d869-3fcf-589297dd17bd@mev.co.uk>
Date:   Wed, 9 Nov 2022 12:50:37 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Content-Language: en-GB
To:     netdev@vger.kernel.org
From:   Ian Abbott <abbotti@mev.co.uk>
Subject: [RFC] option to use proper skew timings for Micrel KSZ9021
Organization: MEV Ltd.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 1c1fff72-51a6-4510-a312-4e3fac47fcb7-1-1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Currently the skew timings in the PHY OF device node for KSZ9021 are 
specified in 200ps steps for historical reasons (due to an error in the 
original KSZ9021 datasheet), but the hardware actually uses 120ps steps. 
  (This is all explained in 
"Documentation/devicetree/bindings/net/micrel-ksz90x1.txt".)

I would like to add an optional boolean property to indicate that the 
skew timing properties are to be interpreted as "proper" skew timings 
(in 120ps steps) rather than fake skew timings.  When this property is 
true, the driver can divide the specified skew timing values by 120 
instead of 200.  The advantage of this is that the same skew timing 
property values can be used in the device node and will apply to both 
KSZ9021 and KSZ9031 as long as the values are in range for both chips. 
(The KSZ9021 supports a larger range that the KSZ9031 for 
"rxdX-skew-ps", "txdX-skew-ps", "rxdv-skew-ps" and "txen-skew-ps", but 
the KSZ9031 has a finer resolution of 60ps compared to the KSZ9021's 120ps.)

I'd like to know if this is a sensible suggestion, and if so, what would 
be a sensible name for the new property?

Best regards,
Ian Abbott

-- 
-=( Ian Abbott <abbotti@mev.co.uk> || MEV Ltd. is a company  )=-
-=( registered in England & Wales.  Regd. number: 02862268.  )=-
-=( Regd. addr.: S11 & 12 Building 67, Europa Business Park, )=-
-=( Bird Hall Lane, STOCKPORT, SK3 0XA, UK. || www.mev.co.uk )=-
