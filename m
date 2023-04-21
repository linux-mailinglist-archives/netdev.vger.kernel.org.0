Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B4B6EA194
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbjDUCVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjDUCVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:21:01 -0400
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF4B2722;
        Thu, 20 Apr 2023 19:20:57 -0700 (PDT)
X-QQ-mid: Yeas43t1682043622t658t06080
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FM9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 6262557014173028678
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <olteanv@gmail.com>, <mengyuanlou@net-swift.com>,
        "'Jarkko Nikula'" <jarkko.nikula@linux.intel.com>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-3-jiawenwu@trustnetic.com> <ec095b8a-00af-4fb7-be11-f643ea75e924@lunn.ch> <03ef01d97372$f2ee26a0$d8ca73e0$@trustnetic.com> <72703dc2-0ee1-41b2-9618-2a3185869cbf@lunn.ch>
In-Reply-To: <72703dc2-0ee1-41b2-9618-2a3185869cbf@lunn.ch>
Subject: RE: [PATCH net-next v3 2/8] i2c: designware: Add driver support for Wangxun 10Gb NIC
Date:   Fri, 21 Apr 2023 10:20:17 +0800
Message-ID: <03f501d973f7$d0c889a0$72599ce0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQILBR3gZkFBC9g1wrfKT5ke1rRywwLGjwA7ApvXcEkCESm4NAMW1Vunrn2IXaA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, April 20, 2023 9:23 PM, Andrew Lunn wrote:
> On Thu, Apr 20, 2023 at 06:29:11PM +0800, Jiawen Wu wrote:
> > On Thursday, April 20, 2023 4:58 AM, Andrew Lunn wrote:
> > > On Wed, Apr 19, 2023 at 04:27:33PM +0800, Jiawen Wu wrote:
> > > > Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> > > > with SFP.
> > > >
> > > > Add platform data to pass IOMEM base address, board flag and other
> > > > parameters, since resource address was mapped on ethernet driver.
> > > >
> > > > The exists IP limitations are dealt as workarounds:
> > > > - IP does not support interrupt mode, it works on polling mode.
> > > > - I2C cannot read continuously, only one byte can at a time.
> > >
> > > Are you really sure about that?
> > >
> > > It is a major limitation for SFP devices. It means you cannot access
> > > the diagnostics, since you need to perform an atomic 2 byte read.
> > >
> > > Or maybe i'm understanding you wrong.
> > >
> > >    Andrew
> > >
> >
> > Maybe I'm a little confused about this. Every time I read a byte info, I have to
> > write a 'read command'. It can normally get the information for SFP devices.
> > But I'm not sure if this is regular I2C behavior.
> 
> I don't know this hardware, so i cannot say what a 'read command'
> actually does. Can you put a bus pirate or similar sort of device on
> the bus and look at the actual I2C signals. Is it performing one I2C
> transaction per byte? If so, that is not good.
> 
> The diagnostic values, things like temperature sensor, voltage sensor,
> received signal power are all 16 bits. You cannot read them using two
> time one byte reads. Say the first read sees a 16bit value of 0x00FF,
> but only reads the first byte. The second read sees a 16bit value of
> 0x0100 but only reads the second byte. You end up with 0x0000. When
> you do a multi byte read, the SFP should do an atomic read of the
> sensor, so you would see either 0x00FF, or 0x0100.
> 
> If your hardware can only do single byte reads, please make sure the
> I2C framework knows this. The SFP driver should then refuse to access
> the diagnostic parts of the SFP, because your I2C bus master hardware
> is too broken. The rest of the SFP should still work.
> 
> 	Andrew.
> 

You may have misunderstood. If you want to read a 16-bit message, the
size of 'i2c_msg.len' is set to 2 in the array that 'flags = I2C_M_RD'.

For example in sfp_i2c_read(), block_size limits the message length of every
time call i2c_transfer() to read, usually it is 16. The one-byte read limit I
mentioned means that during the 16-byte read, I2C device needs to write a
read command and then read the message 16 times to fill the 16-byte buffer,
instead of reading 16 bytes at once after stop command writes.

Before I thought this behavior might be strange, so I mentioned in the commit.

