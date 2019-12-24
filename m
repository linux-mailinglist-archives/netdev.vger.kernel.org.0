Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C52F129E5B
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 08:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbfLXHRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 02:17:10 -0500
Received: from mga05.intel.com ([192.55.52.43]:22794 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfLXHRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 02:17:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Dec 2019 23:17:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="gz'50?scan'50,208,50";a="219368923"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 23 Dec 2019 23:17:05 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ijeRE-0006XR-Tk; Tue, 24 Dec 2019 15:17:04 +0800
Date:   Tue, 24 Dec 2019 15:16:20 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     kbuild-all@lists.01.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 07/11] bpf: tcp: Support tcp_congestion_ops
 in bpf
Message-ID: <201912241525.XySoMk64%lkp@intel.com>
References: <20191221062611.1183363-1-kafai@fb.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2kel3hgcfnjewlql"
Content-Disposition: inline
In-Reply-To: <20191221062611.1183363-1-kafai@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--2kel3hgcfnjewlql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Martin,

I love your patch! Perhaps something to improve:

[auto build test WARNING on bpf-next/master]
[cannot apply to bpf/master net/master v5.5-rc3 next-20191220]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Martin-KaFai-Lau/Introduce-BPF-STRUCT_OPS/20191224-085617
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: s390-debug_defconfig (attached as .config)
compiler: s390-linux-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   kernel/bpf/bpf_struct_ops.c: In function 'bpf_struct_ops_init':
>> kernel/bpf/bpf_struct_ops.c:198:1: warning: the frame size of 1208 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    }
    ^

vim +198 kernel/bpf/bpf_struct_ops.c

d69ac27055a81d Martin KaFai Lau 2019-12-20  113  
d69ac27055a81d Martin KaFai Lau 2019-12-20  114  	module_id = btf_find_by_name_kind(_btf_vmlinux, "module",
d69ac27055a81d Martin KaFai Lau 2019-12-20  115  					  BTF_KIND_STRUCT);
d69ac27055a81d Martin KaFai Lau 2019-12-20  116  	if (module_id < 0) {
d69ac27055a81d Martin KaFai Lau 2019-12-20  117  		pr_warn("Cannot find struct module in btf_vmlinux\n");
d69ac27055a81d Martin KaFai Lau 2019-12-20  118  		return;
d69ac27055a81d Martin KaFai Lau 2019-12-20  119  	}
d69ac27055a81d Martin KaFai Lau 2019-12-20  120  	module_type = btf_type_by_id(_btf_vmlinux, module_id);
d69ac27055a81d Martin KaFai Lau 2019-12-20  121  
b14e6918483a61 Martin KaFai Lau 2019-12-20  122  	for (i = 0; i < ARRAY_SIZE(bpf_struct_ops); i++) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  123  		st_ops = bpf_struct_ops[i];
b14e6918483a61 Martin KaFai Lau 2019-12-20  124  
d69ac27055a81d Martin KaFai Lau 2019-12-20  125  		if (strlen(st_ops->name) + VALUE_PREFIX_LEN >=
d69ac27055a81d Martin KaFai Lau 2019-12-20  126  		    sizeof(value_name)) {
d69ac27055a81d Martin KaFai Lau 2019-12-20  127  			pr_warn("struct_ops name %s is too long\n",
d69ac27055a81d Martin KaFai Lau 2019-12-20  128  				st_ops->name);
d69ac27055a81d Martin KaFai Lau 2019-12-20  129  			continue;
d69ac27055a81d Martin KaFai Lau 2019-12-20  130  		}
d69ac27055a81d Martin KaFai Lau 2019-12-20  131  		sprintf(value_name, "%s%s", VALUE_PREFIX, st_ops->name);
d69ac27055a81d Martin KaFai Lau 2019-12-20  132  
d69ac27055a81d Martin KaFai Lau 2019-12-20  133  		value_id = btf_find_by_name_kind(_btf_vmlinux, value_name,
d69ac27055a81d Martin KaFai Lau 2019-12-20  134  						 BTF_KIND_STRUCT);
d69ac27055a81d Martin KaFai Lau 2019-12-20  135  		if (value_id < 0) {
d69ac27055a81d Martin KaFai Lau 2019-12-20  136  			pr_warn("Cannot find struct %s in btf_vmlinux\n",
d69ac27055a81d Martin KaFai Lau 2019-12-20  137  				value_name);
d69ac27055a81d Martin KaFai Lau 2019-12-20  138  			continue;
d69ac27055a81d Martin KaFai Lau 2019-12-20  139  		}
d69ac27055a81d Martin KaFai Lau 2019-12-20  140  
b14e6918483a61 Martin KaFai Lau 2019-12-20  141  		type_id = btf_find_by_name_kind(_btf_vmlinux, st_ops->name,
b14e6918483a61 Martin KaFai Lau 2019-12-20  142  						BTF_KIND_STRUCT);
b14e6918483a61 Martin KaFai Lau 2019-12-20  143  		if (type_id < 0) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  144  			pr_warn("Cannot find struct %s in btf_vmlinux\n",
b14e6918483a61 Martin KaFai Lau 2019-12-20  145  				st_ops->name);
b14e6918483a61 Martin KaFai Lau 2019-12-20  146  			continue;
b14e6918483a61 Martin KaFai Lau 2019-12-20  147  		}
b14e6918483a61 Martin KaFai Lau 2019-12-20  148  		t = btf_type_by_id(_btf_vmlinux, type_id);
b14e6918483a61 Martin KaFai Lau 2019-12-20  149  		if (btf_type_vlen(t) > BPF_STRUCT_OPS_MAX_NR_MEMBERS) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  150  			pr_warn("Cannot support #%u members in struct %s\n",
b14e6918483a61 Martin KaFai Lau 2019-12-20  151  				btf_type_vlen(t), st_ops->name);
b14e6918483a61 Martin KaFai Lau 2019-12-20  152  			continue;
b14e6918483a61 Martin KaFai Lau 2019-12-20  153  		}
b14e6918483a61 Martin KaFai Lau 2019-12-20  154  
b14e6918483a61 Martin KaFai Lau 2019-12-20  155  		for_each_member(j, t, member) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  156  			const struct btf_type *func_proto;
b14e6918483a61 Martin KaFai Lau 2019-12-20  157  
b14e6918483a61 Martin KaFai Lau 2019-12-20  158  			mname = btf_name_by_offset(_btf_vmlinux,
b14e6918483a61 Martin KaFai Lau 2019-12-20  159  						   member->name_off);
b14e6918483a61 Martin KaFai Lau 2019-12-20  160  			if (!*mname) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  161  				pr_warn("anon member in struct %s is not supported\n",
b14e6918483a61 Martin KaFai Lau 2019-12-20  162  					st_ops->name);
b14e6918483a61 Martin KaFai Lau 2019-12-20  163  				break;
b14e6918483a61 Martin KaFai Lau 2019-12-20  164  			}
b14e6918483a61 Martin KaFai Lau 2019-12-20  165  
b14e6918483a61 Martin KaFai Lau 2019-12-20  166  			if (btf_member_bitfield_size(t, member)) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  167  				pr_warn("bit field member %s in struct %s is not supported\n",
b14e6918483a61 Martin KaFai Lau 2019-12-20  168  					mname, st_ops->name);
b14e6918483a61 Martin KaFai Lau 2019-12-20  169  				break;
b14e6918483a61 Martin KaFai Lau 2019-12-20  170  			}
b14e6918483a61 Martin KaFai Lau 2019-12-20  171  
b14e6918483a61 Martin KaFai Lau 2019-12-20  172  			func_proto = btf_type_resolve_func_ptr(_btf_vmlinux,
b14e6918483a61 Martin KaFai Lau 2019-12-20  173  							       member->type,
b14e6918483a61 Martin KaFai Lau 2019-12-20  174  							       NULL);
b14e6918483a61 Martin KaFai Lau 2019-12-20  175  			if (func_proto &&
b14e6918483a61 Martin KaFai Lau 2019-12-20  176  			    btf_distill_func_proto(&log, _btf_vmlinux,
b14e6918483a61 Martin KaFai Lau 2019-12-20  177  						   func_proto, mname,
b14e6918483a61 Martin KaFai Lau 2019-12-20  178  						   &st_ops->func_models[j])) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  179  				pr_warn("Error in parsing func ptr %s in struct %s\n",
b14e6918483a61 Martin KaFai Lau 2019-12-20  180  					mname, st_ops->name);
b14e6918483a61 Martin KaFai Lau 2019-12-20  181  				break;
b14e6918483a61 Martin KaFai Lau 2019-12-20  182  			}
b14e6918483a61 Martin KaFai Lau 2019-12-20  183  		}
b14e6918483a61 Martin KaFai Lau 2019-12-20  184  
b14e6918483a61 Martin KaFai Lau 2019-12-20  185  		if (j == btf_type_vlen(t)) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  186  			if (st_ops->init(_btf_vmlinux)) {
b14e6918483a61 Martin KaFai Lau 2019-12-20  187  				pr_warn("Error in init bpf_struct_ops %s\n",
b14e6918483a61 Martin KaFai Lau 2019-12-20  188  					st_ops->name);
b14e6918483a61 Martin KaFai Lau 2019-12-20  189  			} else {
b14e6918483a61 Martin KaFai Lau 2019-12-20  190  				st_ops->type_id = type_id;
b14e6918483a61 Martin KaFai Lau 2019-12-20  191  				st_ops->type = t;
d69ac27055a81d Martin KaFai Lau 2019-12-20  192  				st_ops->value_id = value_id;
d69ac27055a81d Martin KaFai Lau 2019-12-20  193  				st_ops->value_type =
d69ac27055a81d Martin KaFai Lau 2019-12-20  194  					btf_type_by_id(_btf_vmlinux, value_id);
b14e6918483a61 Martin KaFai Lau 2019-12-20  195  			}
b14e6918483a61 Martin KaFai Lau 2019-12-20  196  		}
b14e6918483a61 Martin KaFai Lau 2019-12-20  197  	}
b14e6918483a61 Martin KaFai Lau 2019-12-20 @198  }
b14e6918483a61 Martin KaFai Lau 2019-12-20  199  

:::::: The code at line 198 was first introduced by commit
:::::: b14e6918483a61bb02672580bde0aa60f4cce17d bpf: Introduce BPF_PROG_TYPE_STRUCT_OPS

:::::: TO: Martin KaFai Lau <kafai@fb.com>
:::::: CC: 0day robot <lkp@intel.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--2kel3hgcfnjewlql
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--2kel3hgcfnjewlql--
