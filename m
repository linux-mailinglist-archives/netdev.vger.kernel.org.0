Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0EA1769EC
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 02:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgCCBVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 20:21:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:30289 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgCCBVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 20:21:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 17:21:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="239868519"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 02 Mar 2020 17:21:45 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1j8wFk-000E13-Bn; Tue, 03 Mar 2020 09:21:44 +0800
Date:   Tue, 3 Mar 2020 09:20:58 +0800
From:   kbuild test robot <lkp@intel.com>
To:     sunil.kovvuri@gmail.com
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        "davem@davemloft.net, Linu Cherian" <lcherian@marvell.com>,
        Christina Jacob <cjacob@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH 4/7] octeontx2-af: Optimize data retrieval from firmware
Message-ID: <202003030921.xT3PSon4%lkp@intel.com>
References: <1583133568-5674-5-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1583133568-5674-5-git-send-email-sunil.kovvuri@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20200228]
[cannot apply to linus/master ipvs/master sparc-next/master v5.6-rc4 v5.6-rc3 v5.6-rc2 v5.6-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/sunil-kovvuri-gmail-com/octeontx2-Flow-control-support-and-other-misc-changes/20200302-154733
base:    770fbb32d34e5d6298cc2be590c9d2fd6069aa17
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-173-ge0787745-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:722:21: sparse: sparse: incorrect type in assignment (different address spaces)
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:722:21: sparse:    expected struct rvu_fwdata *fwdata
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:722:21: sparse:    got void [noderef] <asn:2> *
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:728:28: sparse: sparse: incorrect type in argument 1 (different address spaces)
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:728:28: sparse:    expected void volatile [noderef] <asn:2> *addr
>> drivers/net/ethernet/marvell/octeontx2/af/rvu.c:728:28: sparse:    got struct rvu_fwdata *fwdata
   drivers/net/ethernet/marvell/octeontx2/af/rvu.c:741:28: sparse: sparse: incorrect type in argument 1 (different address spaces)
   drivers/net/ethernet/marvell/octeontx2/af/rvu.c:741:28: sparse:    expected void volatile [noderef] <asn:2> *addr
   drivers/net/ethernet/marvell/octeontx2/af/rvu.c:741:28: sparse:    got struct rvu_fwdata *fwdata

vim +722 drivers/net/ethernet/marvell/octeontx2/af/rvu.c

   712	
   713	static int rvu_fwdata_init(struct rvu *rvu)
   714	{
   715		u64 fwdbase;
   716		int err;
   717	
   718		/* Get firmware data base address */
   719		err = cgx_get_fwdata_base(&fwdbase);
   720		if (err)
   721			goto fail;
 > 722		rvu->fwdata = ioremap_wc(fwdbase, sizeof(struct rvu_fwdata));
   723		if (!rvu->fwdata)
   724			goto fail;
   725		if (!is_rvu_fwdata_valid(rvu)) {
   726			dev_err(rvu->dev,
   727				"Mismatch in 'fwdata' struct btw kernel and firmware\n");
 > 728			iounmap(rvu->fwdata);
   729			rvu->fwdata = NULL;
   730			return -EINVAL;
   731		}
   732		return 0;
   733	fail:
   734		dev_info(rvu->dev, "Unable to fetch 'fwdata' from firmware\n");
   735		return -EIO;
   736	}
   737	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
