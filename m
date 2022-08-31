Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12AC85A73D9
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 04:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiHaCVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 22:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiHaCVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 22:21:52 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708EA9C8D4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 19:21:48 -0700 (PDT)
X-QQ-mid: Yeas48t1661912419t603t09404
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00000000000000F0FK8000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
To:     "'Andrew Lunn'" <andrew@lunn.ch>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20220830070454.146211-1-jiawenwu@trustnetic.com> <20220830070454.146211-2-jiawenwu@trustnetic.com> <Yw6mFbl8abA1lgma@lunn.ch>
In-Reply-To: <Yw6mFbl8abA1lgma@lunn.ch>
Subject: RE: [PATCH net-next v2 01/16] net: txgbe: Store PCI info
Date:   Wed, 31 Aug 2022 10:20:18 +0800
Message-ID: <025701d8bce0$36fc7300$a4f55900$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQFxw3HAOMjs+mp0EMv9zR33VUwRMQF9YTneArw9OOCudGe4cA==
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday, August 31, 2022 8:07 AM, Andrew Lunn wrote:
> > +/* cmd_addr is used for some special command:
> > + * 1. to be sector address, when implemented erase sector command
> > + * 2. to be flash address when implemented read, write flash address
> > +*/ int txgbe_fmgr_cmd_op(struct txgbe_hw *hw, u32 cmd, u32 cmd_addr)
> > +{
> > +	u32 cmd_val = 0, val = 0;
> > +
> > +	cmd_val = (cmd << SPI_CLK_CMD_OFFSET) |
> > +		  (SPI_CLK_DIV << SPI_CLK_DIV_OFFSET) | cmd_addr;
> > +	wr32(hw, SPI_H_CMD_REG_ADDR, cmd_val);
> > +
> > +	return read_poll_timeout(rd32, val, (val & 0x1), 10,
> SPI_TIME_OUT_VALUE,
> > +				 false, hw, SPI_H_STA_REG_ADDR);
> > +}
> > +
> 
> > +int txgbe_flash_read_dword(struct txgbe_hw *hw, u32 addr, u32 *data)
> > +{
> > +	int ret = 0;
> > +
> > +	ret = txgbe_fmgr_cmd_op(hw, SPI_CMD_READ_DWORD, addr);
> > +	if (ret == -ETIMEDOUT)
> > +		return ret;
> 
> Are you absolutely sure it will never return any other error code?
> The pattern in the kernel is
> 
> > +	if (ret)
> > +		return ret;
> 
> or
> 
> > +	if (ret < 0)
> > +		return ret;
> 

I found that the function 'read_poll_timeout()' only returns 0 or
-ETIMEDOUT.
But I'll fix it to be safe.

> > +int txgbe_check_flash_load(struct txgbe_hw *hw, u32 check_bit) {
> > +	u32 i = 0, reg = 0;
> > +	int err = 0;
> > +
> > +	/* if there's flash existing */
> > +	if (!(rd32(hw, TXGBE_SPI_STATUS) &
> > +	      TXGBE_SPI_STATUS_FLASH_BYPASS)) {
> > +		/* wait hw load flash done */
> > +		for (i = 0; i < TXGBE_MAX_FLASH_LOAD_POLL_TIME; i++) {
> > +			reg = rd32(hw, TXGBE_SPI_ILDR_STATUS);
> > +			if (!(reg & check_bit)) {
> > +				/* done */
> > +				break;
> > +			}
> > +			msleep(200);
> > +		}
> 
> This is what iopoll.h is for. Any sort of loop waiting for something to
happen
> should use one of the helpers in there.
> 

The description of functions in iopoll.h states that maximum sleep time
should be less than 20ms, is it okay to call it here for 200ms.


