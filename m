Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F18C2C906D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728621AbfJBSH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:07:58 -0400
Received: from mga17.intel.com ([192.55.52.151]:65192 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfJBSH5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 14:07:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 11:07:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,249,1566889200"; 
   d="gz'50?scan'50,208,50";a="182121645"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 02 Oct 2019 11:07:52 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iFj2V-000Fds-Fz; Thu, 03 Oct 2019 02:07:51 +0800
Date:   Thu, 3 Oct 2019 02:07:24 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     kbuild-all@01.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 3/9] xdp: Support setting and getting device
 chain map
Message-ID: <201910030245.Ozf2sARI%lkp@intel.com>
References: <157002302784.1302756.2073486805381846919.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jkf3a6h7yi52fdml"
Content-Disposition: inline
In-Reply-To: <157002302784.1302756.2073486805381846919.stgit@alrua-x1>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jkf3a6h7yi52fdml
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi "Toke,

I love your patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Toke-H-iland-J-rgensen/xdp-Support-multiple-programs-on-a-single-interface-through-chain-calls/20191003-005238
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: ia64-defconfig (attached as .config)
compiler: ia64-linux-gcc (GCC) 7.4.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.4.0 make.cross ARCH=ia64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   net/core/dev.c: In function 'dev_xdp_uninstall':
>> net/core/dev.c:8187:3: error: implicit declaration of function 'bpf_map_put_with_uref' [-Werror=implicit-function-declaration]
      bpf_map_put_with_uref(chain_map);
      ^~~~~~~~~~~~~~~~~~~~~
   net/core/dev.c: In function 'dev_change_xdp_fd':
>> net/core/dev.c:8286:15: error: implicit declaration of function 'bpf_map_get_with_uref'; did you mean 'bpf_obj_get_user'? [-Werror=implicit-function-declaration]
      chain_map = bpf_map_get_with_uref(chain_map_fd);
                  ^~~~~~~~~~~~~~~~~~~~~
                  bpf_obj_get_user
>> net/core/dev.c:8286:13: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
      chain_map = bpf_map_get_with_uref(chain_map_fd);
                ^
   cc1: some warnings being treated as errors

vim +/bpf_map_put_with_uref +8187 net/core/dev.c

  8177	
  8178	static void dev_xdp_uninstall(struct net_device *dev)
  8179	{
  8180		struct bpf_map *chain_map = NULL;
  8181		struct netdev_bpf xdp;
  8182		bpf_op_t ndo_bpf;
  8183	
  8184		/* Remove chain map */
  8185		rcu_swap_protected(dev->xdp_chain_map, chain_map, 1);
  8186		if(chain_map)
> 8187			bpf_map_put_with_uref(chain_map);
  8188	
  8189		/* Remove generic XDP */
  8190		WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
  8191	
  8192		/* Remove from the driver */
  8193		ndo_bpf = dev->netdev_ops->ndo_bpf;
  8194		if (!ndo_bpf)
  8195			return;
  8196	
  8197		memset(&xdp, 0, sizeof(xdp));
  8198		xdp.command = XDP_QUERY_PROG;
  8199		WARN_ON(ndo_bpf(dev, &xdp));
  8200		if (xdp.prog_id)
  8201			WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
  8202						NULL));
  8203	
  8204		/* Remove HW offload */
  8205		memset(&xdp, 0, sizeof(xdp));
  8206		xdp.command = XDP_QUERY_PROG_HW;
  8207		if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
  8208			WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
  8209						NULL));
  8210	}
  8211	
  8212	/**
  8213	 *	dev_change_xdp_fd - set or clear a bpf program for a device rx path
  8214	 *	@dev: device
  8215	 *	@extack: netlink extended ack
  8216	 *	@prog_fd: new program fd or negative value to clear
  8217	 *	@chain_map_fd: new chain map fd or negative value to clear
  8218	 *	@flags: xdp-related flags
  8219	 *
  8220	 *	Set or clear a bpf program for a device
  8221	 */
  8222	int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
  8223			      int prog_fd, int chain_map_fd, u32 flags)
  8224	{
  8225		const struct net_device_ops *ops = dev->netdev_ops;
  8226		struct bpf_map *chain_map = NULL;
  8227		enum bpf_netdev_command query;
  8228		struct bpf_prog *prog = NULL;
  8229		bpf_op_t bpf_op, bpf_chk;
  8230		bool offload;
  8231		int err;
  8232	
  8233		ASSERT_RTNL();
  8234	
  8235		offload = flags & XDP_FLAGS_HW_MODE;
  8236		query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
  8237	
  8238		bpf_op = bpf_chk = ops->ndo_bpf;
  8239		if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
  8240			NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
  8241			return -EOPNOTSUPP;
  8242		}
  8243		if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
  8244			bpf_op = generic_xdp_install;
  8245		if (bpf_op == bpf_chk)
  8246			bpf_chk = generic_xdp_install;
  8247	
  8248		if (prog_fd >= 0) {
  8249			u32 prog_id;
  8250	
  8251			if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
  8252				NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
  8253				return -EEXIST;
  8254			}
  8255	
  8256			prog_id = __dev_xdp_query(dev, bpf_op, query);
  8257			if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) && prog_id) {
  8258				NL_SET_ERR_MSG(extack, "XDP program already attached");
  8259				return -EBUSY;
  8260			}
  8261	
  8262			prog = bpf_prog_get_type_dev(prog_fd, BPF_PROG_TYPE_XDP,
  8263						     bpf_op == ops->ndo_bpf);
  8264			if (IS_ERR(prog))
  8265				return PTR_ERR(prog);
  8266	
  8267			if (!offload && bpf_prog_is_dev_bound(prog->aux)) {
  8268				NL_SET_ERR_MSG(extack, "using device-bound program without HW_MODE flag is not supported");
  8269				bpf_prog_put(prog);
  8270				return -EINVAL;
  8271			}
  8272	
  8273			if (prog->aux->id == prog_id) {
  8274				bpf_prog_put(prog);
  8275				return 0;
  8276			}
  8277		} else {
  8278			if (chain_map_fd >= 0)
  8279				return -EINVAL;
  8280	
  8281			if (!__dev_xdp_query(dev, bpf_op, query))
  8282				return 0;
  8283		}
  8284	
  8285		if (chain_map_fd >= 0) {
> 8286			chain_map = bpf_map_get_with_uref(chain_map_fd);
  8287			if (IS_ERR(chain_map))
  8288				return PTR_ERR(chain_map);
  8289	
  8290			if (chain_map->map_type != BPF_MAP_TYPE_XDP_CHAIN) {
  8291				NL_SET_ERR_MSG(extack, "invalid chain map type");
  8292				bpf_map_put_with_uref(chain_map);
  8293				return -EINVAL;
  8294			}
  8295		}
  8296	
  8297		err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
  8298		if (err < 0) {
  8299			if (prog)
  8300				bpf_prog_put(prog);
  8301		} else {
  8302			rcu_swap_protected(dev->xdp_chain_map, chain_map, 1);
  8303		}
  8304	
  8305		if(chain_map)
  8306			bpf_map_put_with_uref(chain_map);
  8307	
  8308		return err;
  8309	}
  8310	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--jkf3a6h7yi52fdml
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--jkf3a6h7yi52fdml--
