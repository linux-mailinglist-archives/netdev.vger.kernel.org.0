Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7EAE7788
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 18:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404145AbfJ1RXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 13:23:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:29992 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730212AbfJ1RXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 13:23:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 10:23:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,240,1569308400"; 
   d="scan'208";a="193326794"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 28 Oct 2019 10:22:58 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iP8jJ-0001Ik-UR; Tue, 29 Oct 2019 01:22:57 +0800
Date:   Tue, 29 Oct 2019 01:21:56 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     kbuild-all@lists.01.org, Lars Poeschel <poeschel@lemonage.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Steve Winslow <swinslow@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <netdev@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Claudiu Beznea <Claudiu.Beznea@microchip.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH v10 5/7] nfc: pn533: add UART phy driver
Message-ID: <201910290150.Mhd8u8Ot%lkp@intel.com>
References: <20191025142521.22695-6-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025142521.22695-6-poeschel@lemonage.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lars,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.4-rc5 next-20191028]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Lars-Poeschel/nfc-pn533-add-uart-phy-driver/20191028-222313
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 0365fb6baeb1ebefbbdad9e3f48bab9b3ccb8df3
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/nfc/pn533/uart.c:174:35: sparse: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [usertype] frame_len @@    got resunsigned short [usertype] frame_len @@
>> drivers/nfc/pn533/uart.c:174:35: sparse:    expected unsigned short [usertype] frame_len
>> drivers/nfc/pn533/uart.c:174:35: sparse:    got restricted __be16 [usertype] datalen

vim +174 drivers/nfc/pn533/uart.c

   133	
   134	/*
   135	 * scans the buffer if it contains a pn532 frame. It is not checked if the
   136	 * frame is really valid. This is later done with pn533_rx_frame_is_valid.
   137	 * This is useful for malformed or errornous transmitted frames. Adjusts the
   138	 * bufferposition where the frame starts, since pn533_recv_frame expects a
   139	 * well formed frame.
   140	 */
   141	static int pn532_uart_rx_is_frame(struct sk_buff *skb)
   142	{
   143		struct pn533_std_frame *std;
   144		struct pn533_ext_frame *ext;
   145		u16 frame_len;
   146		int i;
   147	
   148		for (i = 0; i + PN533_STD_FRAME_ACK_SIZE <= skb->len; i++) {
   149			std = (struct pn533_std_frame *)&skb->data[i];
   150			/* search start code */
   151			if (std->start_frame != cpu_to_be16(PN533_STD_FRAME_SOF))
   152				continue;
   153	
   154			/* frame type */
   155			switch (std->datalen) {
   156			case PN533_FRAME_DATALEN_ACK:
   157				if (std->datalen_checksum == 0xff) {
   158					skb_pull(skb, i);
   159					return 1;
   160				}
   161	
   162				break;
   163			case PN533_FRAME_DATALEN_ERROR:
   164				if ((std->datalen_checksum == 0xff) &&
   165						(skb->len >=
   166						 PN533_STD_ERROR_FRAME_SIZE)) {
   167					skb_pull(skb, i);
   168					return 1;
   169				}
   170	
   171				break;
   172			case PN533_FRAME_DATALEN_EXTENDED:
   173				ext = (struct pn533_ext_frame *)&skb->data[i];
 > 174				frame_len = ext->datalen;
   175				if (skb->len >= frame_len +
   176						sizeof(struct pn533_ext_frame) +
   177						2 /* CKS + Postamble */) {
   178					skb_pull(skb, i);
   179					return 1;
   180				}
   181	
   182				break;
   183			default: /* normal information frame */
   184				frame_len = std->datalen;
   185				if (skb->len >= frame_len +
   186						sizeof(struct pn533_std_frame) +
   187						2 /* CKS + Postamble */) {
   188					skb_pull(skb, i);
   189					return 1;
   190				}
   191	
   192				break;
   193			}
   194		}
   195	
   196		return 0;
   197	}
   198	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
